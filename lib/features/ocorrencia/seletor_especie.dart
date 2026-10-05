import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../data/local/database.dart';
import '../../domain/codigos.dart';
import '../../widgets/comuns.dart';
import '../especies/especie_screen.dart';

/// Escolha da espécie por lista com busca + "Outra espécie / não sei".
class SeletorEspecie extends StatefulWidget {
  const SeletorEspecie({super.key, required this.especies, required this.aoEscolher});

  final List<Especie> especies;
  final ValueChanged<Especie> aoEscolher;

  @override
  State<SeletorEspecie> createState() => _SeletorEspecieState();
}

class _SeletorEspecieState extends State<SeletorEspecie> {
  String _busca = '';

  static String _normalizar(String s) {
    const de = 'áàâãäéèêëíìîïóòôõöúùûüç';
    const para = 'aaaaaeeeeiiiiooooouuuuc';
    final b = StringBuffer();
    for (final ch in s.toLowerCase().split('')) {
      final i = de.indexOf(ch);
      b.write(i >= 0 ? para[i] : ch);
    }
    return b.toString();
  }

  @override
  Widget build(BuildContext context) {
    final q = _normalizar(_busca.trim());
    final catalogo = widget.especies.where((e) => e.id != especieOutra).where((e) {
      if (q.isEmpty) return true;
      return _normalizar([...e.nomesPopulares, e.nomeCientifico, e.familia ?? ''].join(' ')).contains(q);
    }).toList();
    final outra = widget.especies.where((e) => e.id == especieOutra).firstOrNull;
    final t = Theme.of(context).textTheme;

    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: TextField(
          onChanged: (s) => setState(() => _busca = s),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Buscar por nome popular ou científico',
          ),
        ),
      ),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            for (final e in catalogo) ...[
              ListTile(
                minTileHeight: 68,
                leading: CircleAvatar(
                  backgroundColor: LumeCores.nevoa,
                  foregroundColor: LumeCores.verdeFloresta,
                  child: Icon(iconeFormaVida(e.formaVida)),
                ),
                title: Text(_capitalizar(e.nomesPopulares.first), style: t.titleMedium),
                subtitle: Text(
                  e.nomeCientifico,
                  style: t.bodySmall!.copyWith(fontStyle: FontStyle.italic),
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
            ],
            if (catalogo.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
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
          ],
        ),
      ),
    ]);
  }
}

String _capitalizar(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
String capitalizar(String s) => _capitalizar(s);
