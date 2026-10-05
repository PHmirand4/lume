import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/fotos.dart';
import '../../core/formato.dart' as fmt;
import '../../data/repositories/foco_repository.dart';
import '../../domain/codigos.dart';
import '../../domain/regras.dart';
import '../../widgets/comuns.dart';
import '../../widgets/formulario.dart';

/// T06 — Registrar manejo: método → (herbicida se químico) → quantidades →
/// equipe e tempo → destinação → fotos antes/depois.
class ManejoScreen extends ConsumerStatefulWidget {
  const ManejoScreen({super.key, required this.focoId});

  final String focoId;

  @override
  ConsumerState<ManejoScreen> createState() => _ManejoScreenState();
}

class _ManejoScreenState extends ConsumerState<ManejoScreen> {
  String? _metodo;
  final _metodoTexto = TextEditingController();
  final _produto = TextEditingController();
  final _concentracao = TextEditingController();
  final _volume = TextEditingController();
  final _individuos = TextEditingController();
  final _area = TextEditingController();
  final _responsavel = TextEditingController();
  final _obs = TextEditingController();
  int _pessoas = 1;
  double _horas = 1;
  String? _destinacao;
  String? _tempo;
  bool? _epi;
  List<FotoCapturada> _antes = [];
  List<FotoCapturada> _depois = [];
  bool _salvando = false;
  bool _tentou = false;

  @override
  void initState() {
    super.initState();
    _responsavel.text = ref.read(usuarioAtualProvider).value?.nome ?? '';
  }

  @override
  void dispose() {
    for (final c in [_metodoTexto, _produto, _concentracao, _volume, _individuos, _area, _responsavel, _obs]) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _quimico => _metodo != null && manejoExigeHerbicida(_metodo!);

  String? _validar() {
    if (_metodo == null) return 'Escolha o método.';
    if (_metodo == 'outro' && _metodoTexto.text.trim().isEmpty) return 'Descreva o método.';
    if (_quimico && _produto.text.trim().isEmpty) return 'Informe o herbicida usado.';
    if (_responsavel.text.trim().isEmpty) return 'Informe o responsável.';
    return null;
  }

  Future<void> _salvar() async {
    setState(() => _tentou = true);
    final erro = _validar();
    if (erro != null) {
      mostrarMensagem(context, erro);
      return;
    }
    final usuario = ref.read(usuarioAtualProvider).value;
    if (usuario == null) return;
    setState(() => _salvando = true);
    final fim = DateTime.now().toUtc();
    try {
      await ref.read(focoRepoProvider).registrarManejo(
            focoId: widget.focoId,
            usuarioId: usuario.id,
            cfg: ref.read(regrasAtuaisProvider),
            dados: DadosManejo(
              metodo: _metodo!,
              metodoTexto: _metodo == 'outro' ? _metodoTexto.text.trim() : null,
              responsavel: _responsavel.text.trim(),
              nPessoas: _pessoas,
              horas: _horas,
              inicio: fim.subtract(Duration(minutes: (_horas * 60).round())),
              fim: fim,
              herbicidaProduto: _quimico ? _produto.text.trim() : null,
              herbicidaConcentracao: _quimico && _concentracao.text.trim().isNotEmpty ? _concentracao.text.trim() : null,
              herbicidaVolumeL: _quimico ? fmt.lerNumero(_volume.text) : null,
              nIndividuosTratados: fmt.lerInteiro(_individuos.text),
              areaTratadaM2: fmt.lerNumero(_area.text),
              destinacao: _destinacao,
              epiUtilizado: _epi,
              condicaoTempo: _tempo,
              texto: _obs.text.trim().isEmpty ? null : _obs.text.trim(),
              fotos: [..._antes, ..._depois],
            ),
          );
      _antes = [];
      _depois = [];
      ref.read(syncServiceProvider).sincronizar();
      if (!mounted) return;
      mostrarMensagem(context, 'Manejo registrado. Foco em controle.');
      context.pop();
    } catch (e) {
      if (mounted) {
        setState(() => _salvando = false);
        mostrarMensagem(context, 'Não foi possível salvar: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final foco = ref.watch(focoProvider(widget.focoId)).value;
    final vocab = ref.watch(vocabProvider);
    final t = Theme.of(context).textTheme;
    final sugeridos = foco?.especie.metodosSugeridos ?? const <String>[];
    final fotos = [..._antes, ..._depois];

    return PopScope(
      canPop: fotos.isEmpty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await confirmar(context,
            titulo: 'Descartar manejo?', mensagem: 'As fotos tiradas serão apagadas.', confirmar: 'Descartar', perigo: true)) {
          await ServicoFotos.descartar(fotos);
          _antes = [];
          _depois = [];
          if (context.mounted) context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Manejo${foco == null ? '' : ' · ${foco.foco.codigo}'}')),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            if (foco?.especie.controleCitado != null) ...[
              const SizedBox(height: 12),
              Aviso('Controle já usado na Flona para esta espécie: ${foco!.especie.controleCitado}'),
            ],
            TituloSecao('Método', obrigatorio: _tentou && _metodo == null),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final v in vocab.itens(Listas.metodoManejo))
                ChoiceChip(
                  label: Text(v.rotulo),
                  avatar: sugeridos.contains(v.codigo) ? const Icon(Icons.star_outline, size: 18) : null,
                  selected: _metodo == v.codigo,
                  onSelected: (s) => setState(() => _metodo = s ? v.codigo : null),
                ),
            ]),
            if (_metodo == 'outro') ...[
              const SizedBox(height: 10),
              TextField(controller: _metodoTexto, decoration: const InputDecoration(labelText: 'Qual método?')),
            ],
            if (_quimico) ...[
              const TituloSecao('Herbicida', obrigatorio: true,
                  ajuda: 'O Lume só registra o que foi usado; não recomenda produto nem dose.'),
              TextField(
                controller: _produto,
                decoration: InputDecoration(
                  labelText: 'Produto',
                  hintText: 'Ex.: triclopir',
                  errorText: _tentou && _produto.text.trim().isEmpty ? 'Obrigatório no manejo químico' : null,
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: TextField(
                    controller: _concentracao,
                    decoration: const InputDecoration(labelText: 'Concentração', hintText: 'Ex.: 4% em óleo'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _volume,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Volume', suffixText: 'L'),
                  ),
                ),
              ]),
              const TituloSecao('Tempo no momento da aplicação'),
              OpcoesVocabulario(
                vocab: vocab,
                lista: Listas.condicaoTempo,
                valor: _tempo,
                aoMudar: (v) => setState(() => _tempo = v),
              ),
            ],
            const TituloSecao('O que foi tratado'),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _individuos,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Indivíduos', suffixText: 'ind.'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _area,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Área', suffixText: 'm²'),
                ),
              ),
            ]),
            const TituloSecao('Equipe e tempo', ajuda: 'Esforço = pessoas × horas'),
            _Contador(
              rotulo: 'Pessoas',
              valor: '$_pessoas',
              aoMenos: _pessoas > 1 ? () => setState(() => _pessoas--) : null,
              aoMais: () => setState(() => _pessoas++),
            ),
            const SizedBox(height: 8),
            _Contador(
              rotulo: 'Horas',
              valor: fmt.numero(_horas),
              aoMenos: _horas > 0.5 ? () => setState(() => _horas -= 0.5) : null,
              aoMais: () => setState(() => _horas += 0.5),
            ),
            const SizedBox(height: 6),
            Text('Esforço: ${fmt.numero(_pessoas * _horas)} pessoa·hora', style: estiloMono(tamanho: 13, cor: LumeCores.textoSecundario)),
            const SizedBox(height: 12),
            TextField(
              controller: _responsavel,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Responsável técnico / equipe'),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: _epi ?? false,
              onChanged: (v) => setState(() => _epi = v),
              title: Text('EPI utilizado', style: t.bodyLarge),
            ),
            const TituloSecao('Destinação do material'),
            OpcoesVocabulario(
              vocab: vocab,
              lista: Listas.destinacao,
              valor: _destinacao,
              aoMudar: (v) => setState(() => _destinacao = v),
            ),
            const TituloSecao('Foto do antes'),
            FotosFormulario(
              fotos: _antes,
              momento: 'antes',
              rotuloBotao: 'Foto do antes',
              aoMudar: (f) => setState(() => _antes = f),
              posicao: foco == null ? null : () => Posicao(lat: foco.foco.lat, lon: foco.foco.lon),
            ),
            const TituloSecao('Foto do depois'),
            FotosFormulario(
              fotos: _depois,
              momento: 'depois',
              rotuloBotao: 'Foto do depois',
              aoMudar: (f) => setState(() => _depois = f),
              posicao: foco == null ? null : () => Posicao(lat: foco.foco.lat, lon: foco.foco.lon),
            ),
            const TituloSecao('Observação'),
            CampoObservacao(controller: _obs),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: SizedBox(
              height: 60,
              child: FilledButton.icon(
                onPressed: _salvando ? null : _salvar,
                icon: const Icon(Icons.check, size: 26),
                label: Text('Salvar manejo', style: estiloCodigo(tamanho: 17, cor: Colors.white)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Contador extends StatelessWidget {
  const _Contador({required this.rotulo, required this.valor, this.aoMenos, required this.aoMais});

  final String rotulo;
  final String valor;
  final VoidCallback? aoMenos;
  final VoidCallback aoMais;

  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(child: Text(rotulo, style: Theme.of(context).textTheme.titleMedium)),
        IconButton.outlined(
          onPressed: aoMenos,
          icon: const Icon(Icons.remove),
          style: IconButton.styleFrom(minimumSize: const Size(52, 52)),
          tooltip: 'Diminuir $rotulo',
        ),
        SizedBox(
          width: 64,
          child: Text(valor, textAlign: TextAlign.center, style: estiloMono(tamanho: 20)),
        ),
        IconButton.filled(
          onPressed: aoMais,
          icon: const Icon(Icons.add),
          style: IconButton.styleFrom(minimumSize: const Size(52, 52)),
          tooltip: 'Aumentar $rotulo',
        ),
      ]);
}
