import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/formato.dart' as fmt;
import '../../data/repositories/foco_repository.dart';
import '../../domain/codigos.dart';
import '../../widgets/comuns.dart';
import '../../widgets/foco_tile.dart';

/// Filtros da lista de focos (também usados na exportação).
class FiltroFocos {
  const FiltroFocos({
    this.especie,
    this.status = const {},
    this.de,
    this.ate,
    this.soPrecoce = false,
    this.busca = '',
  });

  final String? especie;
  final Set<String> status;
  final DateTime? de;
  final DateTime? ate;
  final bool soPrecoce;
  final String busca;

  bool get vazio => especie == null && status.isEmpty && de == null && ate == null && !soPrecoce && busca.isEmpty;

  bool aceita(FocoComEspecie f) {
    if (especie != null && f.foco.especieId != especie) return false;
    if (status.isNotEmpty && !status.contains(f.foco.status)) return false;
    if (soPrecoce && !f.foco.deteccaoPrecoce) return false;
    // Período: foco com atividade (última visita) dentro do intervalo.
    if (de != null && f.foco.ultimaVisitaEm.isBefore(de!)) return false;
    if (ate != null && f.foco.primeiraDeteccaoEm.isAfter(ate!)) return false;
    if (busca.isNotEmpty) {
      final q = busca.toLowerCase();
      if (!f.foco.codigo.toLowerCase().contains(q) && !f.nomeExibicao.toLowerCase().contains(q)) return false;
    }
    return true;
  }

  FiltroFocos copyWith({
    String? Function()? especie,
    Set<String>? status,
    DateTime? Function()? de,
    DateTime? Function()? ate,
    bool? soPrecoce,
    String? busca,
  }) =>
      FiltroFocos(
        especie: especie != null ? especie() : this.especie,
        status: status ?? this.status,
        de: de != null ? de() : this.de,
        ate: ate != null ? ate() : this.ate,
        soPrecoce: soPrecoce ?? this.soPrecoce,
        busca: busca ?? this.busca,
      );
}

/// Ordena: detecção precoce ativa no topo (RN16), depois pela última visita.
List<FocoComEspecie> ordenarFocos(Iterable<FocoComEspecie> focos) => [...focos]..sort((a, b) {
    int peso(FocoComEspecie f) =>
        f.foco.deteccaoPrecoce && StatusFoco.ativos.contains(f.foco.status) ? 0 : 1;
    final p = peso(a).compareTo(peso(b));
    return p != 0 ? p : b.foco.ultimaVisitaEm.compareTo(a.foco.ultimaVisitaEm);
  });

/// T10 — Lista de focos com filtros e busca por código.
class ListaFocosScreen extends ConsumerStatefulWidget {
  const ListaFocosScreen({super.key});

  @override
  ConsumerState<ListaFocosScreen> createState() => _ListaFocosScreenState();
}

class _ListaFocosScreenState extends ConsumerState<ListaFocosScreen> {
  var _filtro = const FiltroFocos();

  Future<void> _escolherPeriodo() async {
    final agora = DateTime.now();
    final r = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: agora,
      initialDateRange: _filtro.de == null
          ? null
          : DateTimeRange(start: _filtro.de!.toLocal(), end: (_filtro.ate ?? agora.toUtc()).toLocal()),
    );
    if (r == null) return;
    setState(() => _filtro = _filtro.copyWith(
          de: () => r.start.toUtc(),
          ate: () => DateTime(r.end.year, r.end.month, r.end.day, 23, 59, 59).toUtc(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(focosProvider).value ?? const <FocoComEspecie>[];
    final especies = ref.watch(especiesProvider).value ?? const [];
    final focos = ordenarFocos(todos.where(_filtro.aceita));
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Focos')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: TextField(
            onChanged: (s) => setState(() => _filtro = _filtro.copyWith(busca: s.trim())),
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Buscar código (ex.: JAQ-0042) ou nome'),
          ),
        ),
        SizedBox(
          height: 52,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              FilterChip(
                avatar: const Icon(Icons.bolt, size: 18, color: LumeCores.laranjaAlerta),
                label: const Text('Precoce'),
                selected: _filtro.soPrecoce,
                onSelected: (v) => setState(() => _filtro = _filtro.copyWith(soPrecoce: v)),
              ),
              const SizedBox(width: 8),
              _MenuChip(
                rotulo: _filtro.especie == null
                    ? 'Espécie'
                    : especies.where((e) => e.id == _filtro.especie).firstOrNull?.nomesPopulares.first ?? 'Espécie',
                ativo: _filtro.especie != null,
                opcoes: [
                  (null, 'Todas'),
                  for (final e in especies) (e.id, e.nomesPopulares.first),
                ],
                aoEscolher: (v) => setState(() => _filtro = _filtro.copyWith(especie: () => v)),
              ),
              const SizedBox(width: 8),
              _MenuChip(
                rotulo: _filtro.status.isEmpty ? 'Status' : _filtro.status.map((s) => EstiloStatus.de(s).rotulo).join(', '),
                ativo: _filtro.status.isNotEmpty,
                opcoes: [
                  (null, 'Todos'),
                  for (final s in StatusFoco.todos) (s, EstiloStatus.de(s).rotulo),
                ],
                aoEscolher: (v) => setState(() => _filtro = _filtro.copyWith(status: v == null ? {} : {v})),
              ),
              const SizedBox(width: 8),
              FilterChip(
                avatar: const Icon(Icons.date_range, size: 18),
                label: Text(_filtro.de == null ? 'Período' : '${fmt.data(_filtro.de!)} – ${fmt.data(_filtro.ate!)}'),
                selected: _filtro.de != null,
                onSelected: (_) => _escolherPeriodo(),
              ),
              if (!_filtro.vazio) ...[
                const SizedBox(width: 8),
                ActionChip(
                  label: const Text('Limpar'),
                  onPressed: () => setState(() => _filtro = const FiltroFocos()),
                ),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Row(children: [
            Text('${focos.length} ${focos.length == 1 ? 'foco' : 'focos'}', style: t.bodySmall),
          ]),
        ),
        const Divider(),
        Expanded(
          child: focos.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Aviso(todos.isEmpty ? 'Nenhum foco registrado ainda.' : 'Nenhum foco com esses filtros.'),
                )
              : ListView.separated(
                  itemCount: focos.length,
                  separatorBuilder: (_, _) => const Divider(indent: 56),
                  itemBuilder: (_, i) => FocoTile(item: focos[i]),
                ),
        ),
      ]),
    );
  }
}

class _MenuChip extends StatelessWidget {
  const _MenuChip({required this.rotulo, required this.ativo, required this.opcoes, required this.aoEscolher});

  final String rotulo;
  final bool ativo;
  final List<(String?, String)> opcoes;
  final ValueChanged<String?> aoEscolher;

  @override
  Widget build(BuildContext context) => FilterChip(
        label: Row(mainAxisSize: MainAxisSize.min, children: [
          ConstrainedBox(constraints: const BoxConstraints(maxWidth: 160), child: Text(rotulo, overflow: TextOverflow.ellipsis)),
          const Icon(Icons.arrow_drop_down, size: 20),
        ]),
        selected: ativo,
        showCheckmark: false,
        onSelected: (_) async {
          final box = context.findRenderObject() as RenderBox;
          final pos = box.localToGlobal(Offset(0, box.size.height));
          final r = await showMenu<(String?,)>(
            context: context,
            position: RelativeRect.fromLTRB(pos.dx, pos.dy, pos.dx + 1, pos.dy + 1),
            items: [for (final (v, l) in opcoes) PopupMenuItem(value: (v,), child: Text(l))],
          );
          if (r != null) aoEscolher(r.$1);
        },
      );
}
