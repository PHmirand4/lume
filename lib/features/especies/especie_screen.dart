import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../core/fotos.dart';
import '../../data/local/database.dart';
import '../../data/repositories/catalogo_repository.dart';
import '../../domain/codigos.dart';
import '../../widgets/comuns.dart';
import '../ocorrencia/seletor_especie.dart';

final _fotosEspecieProvider = StreamProvider.family<List<Midia>, String>(
    (ref, id) => ref.watch(catalogoRepoProvider).observarFotosEspecie(id));

final _fotosRegistrosProvider = StreamProvider.family<List<Midia>, String>((ref, id) =>
    ref.watch(catalogoRepoProvider).observarFotosRegistros(id, ref.watch(unidadeAtualProvider).id));

/// Ficha de uma espécie: fotos, ocorrências na unidade, como reconhecer,
/// origem, impactos e controle descrito.
class EspecieScreen extends ConsumerStatefulWidget {
  const EspecieScreen({super.key, required this.especieId});

  final String especieId;

  @override
  ConsumerState<EspecieScreen> createState() => _EspecieScreenState();
}

class _EspecieScreenState extends ConsumerState<EspecieScreen> {
  bool _ocupado = false;

  Future<void> _adicionarFoto({required bool galeria}) async {
    setState(() => _ocupado = true);
    try {
      final f = await ServicoFotos().capturar(daGaleria: galeria);
      if (f != null) await ref.read(catalogoRepoProvider).adicionarFoto(widget.especieId, f);
    } catch (e) {
      if (mounted) mostrarMensagem(context, 'Não foi possível adicionar a foto: $e');
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  Future<void> _removerFoto(Midia m) async {
    final ok = await confirmar(context,
        titulo: 'Remover foto?', mensagem: 'A foto sai do catálogo desta espécie.', confirmar: 'Remover', perigo: true);
    if (ok) await ref.read(catalogoRepoProvider).removerFoto(m);
  }

  void _escolherOrigemFoto() {
    showModalBottomSheet<void>(
      context: context,
      builder: (c) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: const Text('Tirar foto'),
            onTap: () {
              Navigator.pop(c);
              _adicionarFoto(galeria: false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Escolher da galeria'),
            onTap: () {
              Navigator.pop(c);
              _adicionarFoto(galeria: true);
            },
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final especies = ref.watch(especiesProvider).value ?? const [];
    final vocab = ref.watch(vocabProvider);
    final unidade = ref.watch(unidadeAtualProvider);
    final e = especies.where((x) => x.id == widget.especieId).firstOrNull;
    final r = ref.watch(resumosEspeciesProvider).value?[widget.especieId] ?? ResumoEspecie.vazio;
    final fotosCatalogo = ref.watch(_fotosEspecieProvider(widget.especieId)).value ?? const [];
    final fotosRegistros = ref.watch(_fotosRegistrosProvider(widget.especieId)).value ?? const [];
    final naLista = ref.watch(listaOficialProvider).value?.contains(widget.especieId);
    final ciclo = ref.watch(cicloListaProvider).value;
    final priorizacao = ref.watch(priorizacoesProvider).value?[widget.especieId];
    final t = Theme.of(context).textTheme;
    if (e == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final outra = e.id == especieOutra;

    Widget secao(String titulo, String? texto) => texto == null
        ? const SizedBox.shrink()
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TituloSecao(titulo),
            Text(texto, style: t.bodyLarge),
          ]);

    return Scaffold(
      appBar: AppBar(
        title: Text(capitalizar(e.nomeComum)),
        actions: [
          if (!outra)
            IconButton(
              tooltip: 'Editar espécie',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.push(Rotas.editarEspecie(e.id)),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
        children: [
          _Fotos(
            catalogo: fotosCatalogo,
            registros: fotosRegistros,
            especie: e,
            ocupado: _ocupado,
            aoAdicionar: outra ? null : _escolherOrigemFoto,
            aoRemover: _removerFoto,
          ),
          const SizedBox(height: 16),
          Text(e.nomeCientifico, style: t.titleMedium!.copyWith(fontStyle: FontStyle.italic)),
          const SizedBox(height: 4),
          Text(
            [
              if (e.nomesPopulares.length > 1) 'Também: ${e.nomesPopulares.skip(1).join(', ')}',
              if (e.familia?.isNotEmpty ?? false) e.familia!,
              vocab.rotulo(Listas.formaVida, e.formaVida),
            ].join(' · '),
            style: t.bodySmall,
          ),
          if (!outra && naLista != null) ...[
            const SizedBox(height: 10),
            Aviso(
              naLista
                  ? 'Consta na Lista oficial de EEI da ${unidade.nomeCurto} (ICMBio${ciclo == null ? '' : ', ciclo $ciclo'}).'
                  : 'Não consta na Lista oficial de EEI da ${unidade.nomeCurto}. Um registro aqui pode ser novo '
                      'para a unidade: informe à Coordenação de Manejo de EEI (CMEEI/ICMBio).',
              tipo: naLista ? TipoAviso.sucesso : TipoAviso.alerta,
              icone: naLista ? Icons.verified_outlined : Icons.new_releases_outlined,
            ),
          ],
          if (e.nativaBrasil) ...[
            const SizedBox(height: 10),
            const Aviso(
              'Nativa do Brasil, mas invasora fora da sua área natural de ocorrência.',
              icone: Icons.public,
            ),
          ],
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(children: [
                Expanded(child: _Numero(r.ocorrencias, r.ocorrencias == 1 ? 'ocorrência' : 'ocorrências')),
                Expanded(child: _Numero(r.ativas, r.ativas == 1 ? 'ativa' : 'ativas', cor: r.ativas > 0 ? LumeCores.laranjaTexto : null)),
                Expanded(child: _Numero(r.registros, r.registros == 1 ? 'registro' : 'registros')),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text('Na ${unidade.nomeCurto}', style: t.bodySmall),
          ),
          if (!outra && (naLista == true || r.ocorrencias > 0)) ...[
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.leaderboard_outlined, color: LumeCores.verdeFloresta),
                title: Text(priorizacao == null
                    ? 'Priorização para controle: não avaliada'
                    : 'Índice de priorização: ${priorizacao.indice}'),
                subtitle: const Text('Ferramenta de Priorização do ICMBio (12 critérios)'),
                trailing: Text(priorizacao == null ? 'Avaliar' : 'Rever'),
                onTap: () => context.push('${Rotas.priorizacao}?especie=${e.id}'),
              ),
            ),
          ],
          secao('Como reconhecer', e.descricaoIdentificacao),
          if (e.confusaoCom != null) ...[
            const SizedBox(height: 16),
            Aviso(e.confusaoCom!, tipo: TipoAviso.alerta, icone: Icons.compare_arrows),
          ],
          secao('Origem', e.origemNativa),
          secao('Onde costuma invadir', e.ambientesInvasao),
          secao('Impactos na biodiversidade', e.impactos),
          secao('Controle já usado pela equipe', e.controleCitado),
          secao('Controle descrito na base nacional', e.controleLiteratura),
          if (e.metodosSugeridos.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final m in e.metodosSugeridos) Chip(label: Text(vocab.rotulo(Listas.metodoManejo, m))),
            ]),
          ],
          const SizedBox(height: 12),
          Text(
            'O BioLume registra o que foi feito, mas não recomenda produto nem dose. '
            'Siga o protocolo de manejo da unidade.',
            style: t.bodySmall,
          ),
          if (e.fonte != null) ...[
            const SizedBox(height: 8),
            Text('Fonte: ${e.fonte}', style: t.bodySmall),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'registrar_especie',
        onPressed: () => context.push('${Rotas.novaOcorrencia}?especie=${e.id}'),
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Registrar ocorrência'),
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
        Text(rotulo, style: Theme.of(context).textTheme.bodySmall),
      ]);
}

/// Faixa de fotos: as de referência (catálogo) e as dos registros de campo.
class _Fotos extends StatelessWidget {
  const _Fotos({
    required this.catalogo,
    required this.registros,
    required this.especie,
    required this.ocupado,
    required this.aoAdicionar,
    required this.aoRemover,
  });

  final List<Midia> catalogo;
  final List<Midia> registros;
  final Especie especie;
  final bool ocupado;
  final VoidCallback? aoAdicionar;
  final ValueChanged<Midia> aoRemover;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final fotos = [
      for (final m in catalogo) (m, true),
      for (final m in registros) (m, false),
    ].where((f) => f.$1.caminhoLocal != null).toList();

    if (fotos.isEmpty) {
      return Container(
        height: 170,
        decoration: BoxDecoration(color: LumeCores.nevoa, borderRadius: BorderRadius.circular(14)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(iconeFormaVida(especie.formaVida), size: 56, color: LumeCores.verdeFloresta),
          const SizedBox(height: 6),
          Text('Ainda sem foto desta espécie', style: t.bodySmall),
          if (aoAdicionar != null) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: ocupado ? null : aoAdicionar,
              icon: const Icon(Icons.add_a_photo_outlined),
              label: const Text('Adicionar foto'),
            ),
          ],
        ]),
      );
    }

    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: fotos.length + (aoAdicionar == null ? 0 : 1),
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          if (i == fotos.length) {
            return SizedBox(
              width: 120,
              child: OutlinedButton(
                onPressed: ocupado ? null : aoAdicionar,
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(8)),
                child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.add_a_photo_outlined),
                  SizedBox(height: 6),
                  Text('Adicionar foto', textAlign: TextAlign.center),
                ]),
              ),
            );
          }
          final (m, doCatalogo) = fotos[i];
          return GestureDetector(
            onTap: () => abrirFoto(context, m.caminhoLocal!),
            onLongPress: doCatalogo ? () => aoRemover(m) : null,
            child: Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(m.caminhoLocal!),
                  width: 190,
                  height: 190,
                  fit: BoxFit.cover,
                  cacheWidth: 570,
                  errorBuilder: (_, _, _) => Container(
                    width: 190,
                    color: LumeCores.nevoa,
                    child: const Icon(Icons.broken_image_outlined),
                  ),
                ),
              ),
              Positioned(
                left: 6,
                bottom: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                  child: Text(doCatalogo ? 'Referência' : 'Registro de campo',
                      style: t.labelSmall!.copyWith(color: Colors.white)),
                ),
              ),
            ]),
          );
        },
      ),
    );
  }
}
