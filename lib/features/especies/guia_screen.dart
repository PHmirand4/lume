import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../data/local/database.dart';
import '../../data/repositories/catalogo_repository.dart';
import '../../domain/codigos.dart';
import '../../domain/regras.dart';
import '../../widgets/comuns.dart';
import '../ocorrencia/seletor_especie.dart';

enum _Escopo { unidade, nacional }

enum _Reino { todos, plantas, animais }

/// T11 — Guia de espécies: na unidade, as da Lista oficial de EEI do ICMBio
/// e as já registradas; no catálogo nacional, flora e fauna exóticas invasoras.
class GuiaScreen extends ConsumerStatefulWidget {
  const GuiaScreen({super.key});

  @override
  ConsumerState<GuiaScreen> createState() => _GuiaScreenState();
}

class _GuiaScreenState extends ConsumerState<GuiaScreen> {
  _Escopo _escopo = _Escopo.unidade;
  _Reino _reino = _Reino.todos;
  String _busca = '';
  String? _forma;

  @override
  Widget build(BuildContext context) {
    final especies = (ref.watch(especiesProvider).value ?? const []).where((e) => e.id != especieOutra).toList();
    final resumos = ref.watch(resumosEspeciesProvider).value ?? const {};
    final lista = ref.watch(listaOficialProvider).value ?? const <String>{};
    final ciclo = ref.watch(cicloListaProvider).value;
    final unidade = ref.watch(unidadeAtualProvider);
    final vocab = ref.watch(vocabProvider);
    final t = Theme.of(context).textTheme;

    bool daUnidade(Especie e) => lista.contains(e.id) || (resumos[e.id]?.ocorrencias ?? 0) > 0;
    bool doReino(Especie e) => switch (_reino) {
          _Reino.todos => true,
          _Reino.plantas => !e.animal,
          _Reino.animais => e.animal,
        };
    final naUnidade = especies.where(daUnidade).length;
    final q = normalizarTexto(_busca);
    final itens = especies.where((e) {
      if (_escopo == _Escopo.unidade && !daUnidade(e)) return false;
      if (!doReino(e)) return false;
      if (_forma != null && e.formaVida != _forma) return false;
      if (q.isEmpty) return true;
      return normalizarTexto([...e.nomesPopulares, e.nomeCientifico, e.familia ?? ''].join(' ')).contains(q);
    }).toList();
    if (_escopo == _Escopo.unidade) {
      // Mais ocorrências primeiro; depois as da lista ainda sem registro.
      itens.sort((a, b) {
        final c = (resumos[b.id]?.ocorrencias ?? 0).compareTo(resumos[a.id]?.ocorrencias ?? 0);
        return c != 0 ? c : capitalizar(a.nomeComum).compareTo(capitalizar(b.nomeComum));
      });
    }
    final formas = {for (final e in especies.where(doReino)) e.formaVida};
    final plantasLista = especies.where((e) => lista.contains(e.id) && !e.animal).length;
    final animaisLista = especies.where((e) => lista.contains(e.id) && e.animal).length;

    return Scaffold(
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Guia de espécies'),
          Text(unidade.nomeCurto, style: t.bodySmall),
        ]),
        actions: [
          IconButton(
            tooltip: 'Priorização para controle',
            icon: const Icon(Icons.leaderboard_outlined),
            onPressed: () => context.push(Rotas.priorizacao),
          ),
        ],
      ),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              SegmentedButton<_Escopo>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(value: _Escopo.unidade, label: Text('Nesta unidade ($naUnidade)')),
                  ButtonSegment(value: _Escopo.nacional, label: Text('Catálogo nacional (${especies.length})')),
                ],
                selected: {_escopo},
                onSelectionChanged: (s) => setState(() => _escopo = s.first),
              ),
              if (_escopo == _Escopo.unidade) ...[
                const SizedBox(height: 8),
                Text(
                  lista.isEmpty
                      ? 'A ${unidade.nomeCurto} não tem espécies na Lista oficial de EEI do ICMBio'
                          '${ciclo == null ? '' : ' (ciclo $ciclo)'}. Qualquer registro aqui é um possível novo registro.'
                      : 'Lista oficial de EEI do ICMBio${ciclo == null ? '' : ' (ciclo $ciclo)'}: '
                          '$plantasLista ${plantasLista == 1 ? 'planta' : 'plantas'} e '
                          '$animaisLista ${animaisLista == 1 ? 'animal' : 'animais'}, mais as espécies já registradas.',
                  style: t.bodySmall,
                ),
              ],
              const SizedBox(height: 10),
              TextField(
                onChanged: (s) => setState(() => _busca = s),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Nome popular, científico ou família',
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  for (final (r, rotulo, icone) in [
                    (_Reino.todos, 'Todas', Icons.all_inclusive),
                    (_Reino.plantas, 'Plantas', Icons.eco_outlined),
                    (_Reino.animais, 'Animais', Icons.pets_outlined),
                  ])
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        avatar: Icon(icone, size: 18),
                        label: Text(rotulo),
                        selected: _reino == r,
                        onSelected: (_) => setState(() {
                          _reino = r;
                          _forma = null;
                        }),
                      ),
                    ),
                  const SizedBox(width: 6),
                  for (final f in vocab.itens(Listas.formaVida).where((v) => formas.contains(v.codigo)))
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        avatar: Icon(iconeFormaVida(f.codigo), size: 18),
                        label: Text(f.rotulo),
                        selected: _forma == f.codigo,
                        onSelected: (s) => setState(() => _forma = s ? f.codigo : null),
                      ),
                    ),
                ]),
              ),
            ]),
          ),
        ),
        if (itens.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Aviso(
                _escopo == _Escopo.unidade && naUnidade == 0
                    ? 'Nenhuma espécie na lista oficial ou registrada na ${unidade.nomeCurto} ainda. '
                        'Veja o catálogo nacional ou registre uma ocorrência.'
                    : 'Nenhuma espécie encontrada. Se for uma espécie nova, cadastre no botão abaixo.',
              ),
            ),
          ),
        SliverList.builder(
          itemCount: itens.length,
          itemBuilder: (context, i) {
            final e = itens[i];
            final r = resumos[e.id] ?? ResumoEspecie.vazio;
            final naLista = lista.contains(e.id);
            return Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                minTileHeight: 84,
                leading: AvatarEspecie(especie: e, foto: r.foto, raio: 28),
                title: Text(capitalizar(e.nomeComum)),
                subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    [e.binomio, [vocab.rotulo(Listas.formaVida, e.formaVida), ?e.familia].join(' · ')].join('\n'),
                    style: t.bodySmall,
                  ),
                  if (naLista || (r.ocorrencias > 0 && !naLista && _escopo == _Escopo.unidade)) ...[
                    const SizedBox(height: 4),
                    naLista
                        ? const SeloListaOficial()
                        : const SeloListaOficial(fora: true),
                  ],
                ]),
                trailing: r.ocorrencias == 0
                    ? (e.cadastradaNoApp
                        ? const Tooltip(message: 'Cadastrada pela equipe', child: Icon(Icons.person_add_alt, size: 20))
                        : null)
                    : _Contagem(r),
                onTap: () => context.push(Rotas.especie(e.id)),
              ),
              const Divider(indent: 88),
            ]);
          },
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
            child: Text(
              'Fontes: Lista de EEI em UC federais (ICMBio, Portaria 510/2025); Base de Dados Nacional de '
              'Espécies Exóticas Invasoras (Instituto Hórus); Costa et al. (2024) para a Flona de Pacotuba; '
              'e espécies cadastradas pela equipe.',
              style: t.bodySmall,
            ),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'nova_especie',
        onPressed: () => context.push(Rotas.novaEspecie),
        icon: const Icon(Icons.library_add_outlined),
        label: const Text('Adicionar espécie'),
      ),
    );
  }
}

class _Contagem extends StatelessWidget {
  const _Contagem(this.r);

  final ResumoEspecie r;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('${r.ocorrencias}', style: estiloCodigo(tamanho: 20, cor: LumeCores.verdeFloresta)),
        Text(r.ocorrencias == 1 ? 'ocorrência' : 'ocorrências', style: t.bodySmall),
        if (r.ativas > 0)
          Text('${r.ativas} ${r.ativas == 1 ? 'ativa' : 'ativas'}',
              style: estiloMono(tamanho: 11.5, cor: LumeCores.laranjaTexto)),
      ],
    );
  }
}
