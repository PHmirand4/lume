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
import '../especies/especie_screen.dart';

/// Escolha da espécie no catálogo nacional, com busca. As espécies já
/// registradas na unidade vêm primeiro; no fim, "Outra espécie / não sei" e
/// o cadastro de espécie nova.
class SeletorEspecie extends ConsumerStatefulWidget {
  const SeletorEspecie({super.key, required this.especies, required this.aoEscolher});

  final List<Especie> especies;
  final ValueChanged<Especie> aoEscolher;

  @override
  ConsumerState<SeletorEspecie> createState() => _SeletorEspecieState();
}

class _SeletorEspecieState extends ConsumerState<SeletorEspecie> {
  String _busca = '';
  bool? _animal; // nulo = todas

  Future<void> _cadastrarNova() async {
    final nome = _busca.trim();
    final id = await context.push<String>(
        nome.isEmpty ? Rotas.novaEspecie : '${Rotas.novaEspecie}?nome=${Uri.encodeQueryComponent(nome)}');
    if (id == null || !mounted) return;
    final nova = await ref.read(catalogoRepoProvider).especie(id);
    if (nova != null) widget.aoEscolher(nova);
  }

  @override
  Widget build(BuildContext context) {
    final resumos = ref.watch(resumosEspeciesProvider).value ?? const {};
    final lista = ref.watch(listaOficialProvider).value ?? const <String>{};
    final q = normalizarTexto(_busca);
    // 0 = já registrada na unidade, 1 = na lista oficial da unidade, 2 = resto do catálogo.
    int grupo(Especie e) => (resumos[e.id]?.ocorrencias ?? 0) > 0 ? 0 : (lista.contains(e.id) ? 1 : 2);
    final catalogo = widget.especies.where((e) => e.id != especieOutra).where((e) {
      if (_animal != null && e.animal != _animal) return false;
      if (q.isEmpty) return true;
      return normalizarTexto([...e.nomesPopulares, e.nomeCientifico, e.familia ?? ''].join(' ')).contains(q);
    }).toList()
      ..sort((a, b) {
        final g = grupo(a).compareTo(grupo(b));
        if (g != 0) return g;
        final n = (resumos[b.id]?.ocorrencias ?? 0).compareTo(resumos[a.id]?.ocorrencias ?? 0);
        return n != 0 ? n : a.ordem.compareTo(b.ordem);
      });
    final outra = widget.especies.where((e) => e.id == especieOutra).firstOrNull;
    final t = Theme.of(context).textTheme;

    Widget cabecalho(String texto) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: Text(texto.toUpperCase(), style: t.labelSmall!.copyWith(color: LumeCores.textoSecundario)),
        );

    final rodape = <Widget>[
      if (catalogo.isEmpty)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text('Nenhuma espécie do catálogo com "$_busca".', style: t.bodyMedium),
        ),
      if (outra != null)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(60),
              foregroundColor: LumeCores.laranjaTexto,
              side: const BorderSide(color: LumeCores.laranjaAlerta, width: 1.5),
            ),
            onPressed: () => widget.aoEscolher(outra),
            icon: const Icon(Icons.help_outline),
            label: const Text('Outra espécie / não sei'),
          ),
        ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(56)),
          onPressed: _cadastrarNova,
          icon: const Icon(Icons.library_add_outlined),
          label: Text(_busca.trim().isEmpty ? 'Cadastrar espécie nova no catálogo' : 'Cadastrar "${_busca.trim()}"'),
        ),
      ),
    ];

    // Cabeçalhos de grupo só sem busca.
    const titulos = ['Já registradas nesta unidade', 'Lista oficial da unidade (ICMBio)', 'Catálogo nacional'];
    final itens = <Object>[
      for (var i = 0; i < catalogo.length; i++) ...[
        if (q.isEmpty && (i == 0 || grupo(catalogo[i]) != grupo(catalogo[i - 1]))) titulos[grupo(catalogo[i])],
        catalogo[i],
      ],
    ];

    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: TextField(
          onChanged: (s) => setState(() => _busca = s),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Buscar por nome popular, científico ou família',
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Row(children: [
          for (final (valor, rotulo) in [(null, 'Todas'), (false, 'Plantas'), (true, 'Animais')])
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChoiceChip(
                label: Text(rotulo),
                selected: _animal == valor,
                onSelected: (_) => setState(() => _animal = valor),
              ),
            ),
          const Spacer(),
          Text('${catalogo.length} espécies', style: t.bodySmall),
        ]),
      ),
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: itens.length + rodape.length,
          itemBuilder: (context, i) {
            if (i >= itens.length) return rodape[i - itens.length];
            final item = itens[i];
            if (item is String) return cabecalho(item);
            final e = item as Especie;
            final r = resumos[e.id] ?? ResumoEspecie.vazio;
            return Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                minTileHeight: 68,
                leading: AvatarEspecie(especie: e, foto: r.foto),
                title: Text(capitalizar(e.nomeComum), style: t.titleMedium),
                subtitle: Text(
                  r.ocorrencias > 0
                      ? '${e.binomio} · ${r.ocorrencias} ${r.ocorrencias == 1 ? 'ocorrência' : 'ocorrências'}'
                      : e.binomio,
                  style: t.bodySmall!.copyWith(fontStyle: r.ocorrencias > 0 ? null : FontStyle.italic),
                ),
                trailing: IconButton(
                  tooltip: 'Como reconhecer',
                  icon: const Icon(Icons.info_outline),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => EspecieScreen(especieId: e.id),
                  )),
                ),
                onTap: () => widget.aoEscolher(e),
              ),
              const Divider(indent: 72),
            ]);
          },
        ),
      ),
    ]);
  }
}

String _capitalizar(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
String capitalizar(String s) => _capitalizar(s);
