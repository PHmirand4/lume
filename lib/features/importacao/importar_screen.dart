import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../core/formato.dart' as fmt;
import '../../core/recursos.dart';
import '../../data/importacao/leitor_planilha.dart';
import '../../domain/importacao.dart';
import '../../widgets/comuns.dart';

/// Importação de planilhas, em dois modos (reconhecidos pelo arquivo):
/// - Lista de EEI em UC federais (ICMBio): atualiza a lista oficial de cada
///   Flona e cadastra as espécies que faltam no catálogo — a cada novo ciclo.
/// - Registros de campo (ex.: ficha do ICMBio digitada): cada linha vira um
///   foco na unidade atual; importar de novo só acrescenta as linhas novas.
class ImportarScreen extends ConsumerStatefulWidget {
  const ImportarScreen({super.key});

  @override
  ConsumerState<ImportarScreen> createState() => _ImportarScreenState();
}

class _ImportarScreenState extends ConsumerState<ImportarScreen> {
  String? _arquivo;
  Planilha? _planilha;
  int _linhaCabecalho = 0;
  Map<CampoImportacao, int> _colunas = {};
  List<RegistroImportado> _registros = [];
  Map<String, bool> _noCatalogo = {};
  List<LinhaListaOficial>? _listaOficial;
  int _ciclo = DateTime.now().year;
  String? _erro;
  bool _ocupado = false;

  List<String> get _cabecalho =>
      _planilha == null || _planilha!.linhas.isEmpty ? const [] : _planilha!.linhas[_linhaCabecalho];

  Future<void> _escolherArquivo() async {
    setState(() {
      _ocupado = true;
      _erro = null;
    });
    try {
      final f = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const ['xlsx', 'csv', 'txt'],
      );
      if (f == null) return;
      final p = lerPlanilha(await f.readAsBytes(), f.name);
      if (p.linhas.isEmpty) throw FalhaPlanilha('A planilha está vazia.');
      _arquivo = f.name;
      _planilha = p;
      // Lista oficial do ICMBio: abas com CNUC e Espécie (Lista Flora, Lista Fauna).
      final abasLista = p.abas.where((a) => a.linhas.isNotEmpty && ehListaOficial(a.linhas.first));
      if (abasLista.isNotEmpty) {
        _listaOficial = [for (final a in abasLista) ...lerListaOficial(a.linhas)];
        _ciclo = cicloDoArquivo(f.name) ?? DateTime.now().year;
        _registros = [];
        return;
      }
      _listaOficial = null;
      _linhaCabecalho = acharLinhaCabecalho(p.linhas);
      _colunas = detectarColunas(_cabecalho);
      await _interpretar();
    } on FalhaPlanilha catch (e) {
      _erro = e.mensagem;
    } catch (e) {
      _erro = 'Não foi possível ler o arquivo: $e';
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  Future<void> _interpretar() async {
    final p = _planilha!;
    _registros = interpretarLinhas(p.linhas.skip(_linhaCabecalho + 1).toList(), _colunas,
        primeiraLinha: _linhaCabecalho + 2, cabecalho: _cabecalho);
    // Quais nomes da planilha existem no catálogo.
    final catalogo = ref.read(catalogoRepoProvider);
    final nomes = {for (final r in _registros.where((r) => r.valido)) r.nomeParaBusca};
    final achados = <String, bool>{};
    for (final n in nomes) {
      achados[n] = await catalogo.procurar(n) != null;
    }
    if (mounted) setState(() => _noCatalogo = achados);
  }

  Future<void> _importar() async {
    final usuario = ref.read(usuarioAtualProvider).value;
    if (usuario == null) return;
    final unidade = ref.read(unidadeAtualProvider);
    final validos = _registros.where((r) => r.valido).length;
    final ok = await confirmar(
      context,
      titulo: 'Importar $validos registros?',
      mensagem: 'Eles entram como focos na ${unidade.nomeCurto}. '
          'Linhas já importadas antes não se repetem.',
      confirmar: 'Importar',
    );
    if (!ok) return;
    setState(() => _ocupado = true);
    try {
      final r = await ref.read(focoRepoProvider).importar(
            unidadeId: unidade.id,
            usuarioId: usuario.id,
            arquivo: _arquivo!,
            registros: _registros,
          );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Importação concluída'),
          content: Text([
            '${r.novos} ${r.novos == 1 ? 'registro novo' : 'registros novos'}',
            if (r.repetidos > 0) '${r.repetidos} já tinham sido importados',
            if (r.invalidos > 0) '${r.invalidos} com erro (não entraram)',
            if (r.semEspecie > 0) '${r.semEspecie} como "outra espécie" (nome fora do catálogo)',
          ].join('\n')),
          actions: [FilledButton(onPressed: () => Navigator.pop(c), child: const Text('OK'))],
        ),
      );
      if (mounted) context.go(Rotas.focos);
    } catch (e) {
      if (mounted) mostrarMensagem(context, 'Falha na importação: $e');
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  Future<void> _importarLista() async {
    final linhas = _listaOficial!;
    final unidades = ref.read(unidadesProvider);
    final porCnuc = {for (final u in unidades.todas) u.cnuc: u.id};
    final ok = await confirmar(
      context,
      titulo: 'Atualizar a lista oficial (ciclo $_ciclo)?',
      mensagem: 'A lista de EEI de cada Flona presente no arquivo será trocada pela deste arquivo, '
          'e as espécies que faltam entram no catálogo. Os focos registrados não mudam.',
      confirmar: 'Atualizar',
    );
    if (!ok) return;
    setState(() => _ocupado = true);
    try {
      final r = await ref.read(catalogoRepoProvider).importarListaOficial(
            linhas,
            unidadePorCnuc: porCnuc,
            ciclo: _ciclo,
            fonte: 'Lista de EEI em UC federais (ICMBio), ciclo $_ciclo — importada de $_arquivo',
          );
      if (!mounted) return;
      final atual = ref.read(unidadeAtualProvider);
      final especies = {for (final e in ref.read(especiesProvider).value ?? const []) e.id: e};
      String nomes(Set<String> ids) => ids.map((id) => especies[id]?.binomio ?? id).join(', ');
      final entraram = r.entraram(atual.id), sairam = r.sairam(atual.id);
      await showDialog<void>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Lista oficial atualizada'),
          content: SingleChildScrollView(
            child: Text([
              '${r.unidades} Flonas atualizadas (ciclo $_ciclo).',
              if (r.especiesNovasNoCatalogo.isNotEmpty)
                '${r.especiesNovasNoCatalogo.length} espécies novas no catálogo.',
              if (r.linhasIgnoradas > 0) '${r.linhasIgnoradas} linhas de outras UC (parques, reservas…) ficaram de fora.',
              if (r.depois.containsKey(atual.id)) ...[
                '',
                '${atual.nomeCurto}: ${r.depois[atual.id]!.length} espécies na lista.',
                if (entraram.isNotEmpty) 'Entraram: ${nomes(entraram)}.',
                if (sairam.isNotEmpty) 'Saíram: ${nomes(sairam)}.',
              ],
            ].join('\n')),
          ),
          actions: [FilledButton(onPressed: () => Navigator.pop(c), child: const Text('OK'))],
        ),
      );
      if (mounted) context.go(Rotas.guia);
    } catch (e) {
      if (mounted) mostrarMensagem(context, 'Falha ao atualizar a lista: $e');
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  Widget _previaLista(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final unidades = ref.watch(unidadesProvider);
    final unidade = ref.watch(unidadeAtualProvider);
    final linhas = _listaOficial!;
    final porCnuc = {for (final u in unidades.todas) u.cnuc: u};
    final ucs = {for (final l in linhas) l.cnuc};
    final flonas = ucs.where(porCnuc.containsKey).length;
    final daUnidade = linhas.where((l) => l.cnuc == unidade.cnuc).toList();
    final animais = linhas.where((l) => l.animal).length;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SizedBox(height: 12),
      const Aviso(
        'Arquivo reconhecido como a Lista de EEI em UC federais do ICMBio.',
        tipo: TipoAviso.sucesso,
        icone: Icons.verified_outlined,
      ),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _Numero(linhas.length, 'registros\n(espécie × UC)')),
        Expanded(child: _Numero(ucs.length, 'UC no\narquivo')),
        Expanded(child: _Numero(flonas, 'Flonas\natendidas')),
      ]),
      const SizedBox(height: 8),
      Text('${linhas.length - animais} registros de flora e $animais de fauna. '
          'As linhas de parques, reservas e outras categorias ficam de fora por enquanto.', style: t.bodySmall),
      const TituloSecao('Ciclo'),
      Row(children: [
        IconButton.outlined(onPressed: () => setState(() => _ciclo--), icon: const Icon(Icons.remove)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('$_ciclo', style: estiloCodigo(tamanho: 22)),
        ),
        IconButton.outlined(onPressed: () => setState(() => _ciclo++), icon: const Icon(Icons.add)),
      ]),
      TituloSecao('${unidade.nomeCurto} neste arquivo'),
      if (daUnidade.isEmpty)
        Text('Nenhuma espécie listada para esta unidade.', style: t.bodyMedium)
      else
        Text(
          daUnidade.map((l) => '${l.especie}${l.nomePopular == null ? '' : ' (${l.nomePopular!.split(',').first.trim()})'}').join('; '),
          style: t.bodyMedium,
        ),
      const SizedBox(height: 20),
      FilledButton.icon(
        onPressed: importacaoPlanilhasAtiva && !_ocupado ? _importarLista : null,
        icon: const Icon(Icons.sync),
        label: const Text('Atualizar lista oficial'),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final unidade = ref.watch(unidadeAtualProvider);
    final t = Theme.of(context).textTheme;
    final validos = _registros.where((r) => r.valido).toList();
    final comErro = _registros.where((r) => !r.valido).toList();
    final foraCatalogo = _noCatalogo.entries.where((e) => !e.value).map((e) => e.key).toList()..sort();

    return Scaffold(
      appBar: AppBar(title: const Text('Importar planilha')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        children: [
          if (!importacaoPlanilhasAtiva)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Aviso(
                'Em preparação: dá para abrir uma planilha e ver a prévia, mas a gravação será liberada '
                'depois de conferirmos as planilhas da equipe.',
                tipo: TipoAviso.alerta,
              ),
            ),
          Text(
            'Dois tipos de planilha (.xlsx ou .csv):\n'
            '• Lista de EEI em UC federais do ICMBio: atualiza a lista oficial de cada Flona a cada novo ciclo.\n'
            '• Registros de campo (ex.: a ficha de campo digitada): cada linha vira um foco na ${unidade.nomeCurto}; '
            'ao importar de novo uma versão atualizada, só as linhas novas entram.',
            style: t.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Colunas reconhecidas nos registros: Nº/código, espécie (popular ou científico), coordenadas '
            '(latitude/longitude ou S/W), data, nº de indivíduos, CAP, fase, bloco, ocorrência, cobertura, '
            'observação, local e responsável.',
            style: t.bodySmall,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _ocupado ? null : _escolherArquivo,
            icon: const Icon(Icons.upload_file),
            label: Text(_arquivo == null ? 'Escolher planilha' : 'Trocar planilha'),
          ),
          if (_erro != null) ...[
            const SizedBox(height: 12),
            Aviso(_erro!, tipo: TipoAviso.erro),
          ],
          if (_ocupado) const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())),
          if (_listaOficial != null && !_ocupado) _previaLista(context),
          if (_planilha != null && _listaOficial == null && !_ocupado) ...[
            const SizedBox(height: 12),
            Text('$_arquivo · aba "${_planilha!.nomeAba}" · cabeçalho na linha ${_linhaCabecalho + 1}',
                style: t.bodySmall),
            const TituloSecao('Colunas', ajuda: 'Confira se cada informação está na coluna certa.'),
            for (final c in CampoImportacao.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  Expanded(child: Text(c.rotulo, style: t.bodyMedium)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButton<int?>(
                      isExpanded: true,
                      value: _colunas[c],
                      hint: const Text('—'),
                      items: [
                        const DropdownMenuItem<int?>(value: null, child: Text('— não usar')),
                        for (var i = 0; i < _cabecalho.length; i++)
                          DropdownMenuItem<int?>(
                            value: i,
                            child: Text(_cabecalho[i].isEmpty ? 'Coluna ${i + 1}' : _cabecalho[i],
                                overflow: TextOverflow.ellipsis),
                          ),
                      ],
                      onChanged: (v) {
                        setState(() {
                          if (v == null) {
                            _colunas.remove(c);
                          } else {
                            _colunas.removeWhere((_, i) => i == v);
                            _colunas[c] = v;
                          }
                        });
                        _interpretar();
                      },
                    ),
                  ),
                ]),
              ),
            const TituloSecao('Prévia'),
            Row(children: [
              Expanded(child: _Numero(validos.length, 'prontos')),
              Expanded(child: _Numero(comErro.length, 'com erro', cor: comErro.isEmpty ? null : LumeCores.erro)),
              Expanded(child: _Numero(foraCatalogo.length, 'nomes fora\ndo catálogo',
                  cor: foraCatalogo.isEmpty ? null : LumeCores.aviso)),
            ]),
            if (foraCatalogo.isNotEmpty) ...[
              const SizedBox(height: 10),
              Aviso(
                'Entram como "outra espécie" (cadastre no Guia antes, se forem invasoras conhecidas): '
                '${foraCatalogo.take(12).join(', ')}${foraCatalogo.length > 12 ? '…' : ''}',
                tipo: TipoAviso.alerta,
              ),
            ],
            const SizedBox(height: 10),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(children: [
                for (final r in [...comErro.take(10), ...validos.take(10)])
                  ListTile(
                    dense: true,
                    leading: Icon(r.valido ? Icons.check_circle_outline : Icons.error_outline,
                        color: r.valido ? LumeCores.verdeFloresta : LumeCores.erro),
                    title: Text('Linha ${r.linha}: ${r.nomeParaBusca.isEmpty ? '(sem espécie)' : r.nomeParaBusca}'),
                    subtitle: Text(
                      r.valido
                          ? [
                              '${r.lat!.toStringAsFixed(5)}, ${r.lon!.toStringAsFixed(5)}',
                              if (r.data != null) fmt.data(r.data!),
                              if (r.quantidade != null) '${r.quantidade} ind.',
                            ].join(' · ')
                          : r.erros.join('; '),
                      style: r.valido ? estiloMono(tamanho: 12) : t.bodySmall!.copyWith(color: LumeCores.erro),
                    ),
                  ),
              ]),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: importacaoPlanilhasAtiva && validos.isNotEmpty && !_ocupado ? _importar : null,
              icon: const Icon(Icons.download_done),
              label: Text(importacaoPlanilhasAtiva
                  ? 'Importar ${validos.length} registros'
                  : 'Importação disponível em breve'),
            ),
          ],
        ],
      ),
    );
  }
}

class _Numero extends StatelessWidget {
  const _Numero(this.valor, this.rotulo, {this.cor});

  final int valor;
  final String rotulo;
  final Color? cor;

  @override
  Widget build(BuildContext context) => Column(children: [
        Text('$valor', style: estiloCodigo(tamanho: 24, cor: cor ?? LumeCores.verdeFloresta)),
        Text(rotulo, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
      ]);
}
