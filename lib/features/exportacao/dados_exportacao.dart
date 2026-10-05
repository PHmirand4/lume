import 'package:drift/drift.dart';

import '../../data/local/database.dart';
import '../../data/repositories/foco_repository.dart';
import '../lista/lista_focos_screen.dart';

/// Recorte de dados para exportar: focos filtrados e as observações/manejos
/// deles dentro do período.
class DadosExportacao {
  DadosExportacao({
    required this.focos,
    required this.observacoes,
    required this.manejos,
    required this.midias,
    required this.usuarios,
    required this.de,
    required this.ate,
  });

  final List<FocoComEspecie> focos;
  final List<Observacao> observacoes;
  final List<AcaoManejo> manejos;
  final List<Midia> midias;
  final Map<String, Usuario> usuarios;
  final DateTime? de;
  final DateTime? ate;

  late final Map<String, FocoComEspecie> focoPorId = {for (final f in focos) f.foco.id: f};

  int fotosDe(String donoId) => midias.where((m) => m.donoId == donoId).length;

  String nomeUsuario(String id) => usuarios[id]?.nome ?? id.substring(0, 8);

  static Future<DadosExportacao> coletar(AppDatabase db, FiltroFocos filtro) async {
    final linhas = await (db.select(db.focos).join([
      innerJoin(db.especies, db.especies.id.equalsExp(db.focos.especieId)),
    ])
          ..where(db.focos.deleted.equals(false))
          ..orderBy([OrderingTerm.asc(db.focos.codigo)]))
        .get();
    final focos = [
      for (final l in linhas) FocoComEspecie(l.readTable(db.focos), l.readTable(db.especies)),
    ].where(filtro.aceita).toList();
    final ids = focos.map((f) => f.foco.id).toList();

    bool noPeriodo(DateTime d) =>
        (filtro.de == null || !d.isBefore(filtro.de!)) && (filtro.ate == null || !d.isAfter(filtro.ate!));

    final obs = ids.isEmpty
        ? <Observacao>[]
        : (await (db.select(db.observacoes)
                  ..where((o) => o.focoId.isIn(ids) & o.deleted.equals(false))
                  ..orderBy([(o) => OrderingTerm.asc(o.dataHora)]))
                .get())
            .where((o) => noPeriodo(o.dataHora))
            .toList();
    final manejos = ids.isEmpty
        ? <AcaoManejo>[]
        : (await (db.select(db.acoesManejo)
                  ..where((m) => m.focoId.isIn(ids) & m.deleted.equals(false))
                  ..orderBy([(m) => OrderingTerm.asc(m.dataHoraInicio)]))
                .get())
            .where((m) => noPeriodo(m.dataHoraInicio))
            .toList();
    final donos = [...obs.map((o) => o.id), ...manejos.map((m) => m.id)];
    final midias = donos.isEmpty
        ? <Midia>[]
        : await (db.select(db.midias)..where((m) => m.donoId.isIn(donos) & m.deleted.equals(false))).get();
    final usuarios = {for (final u in await db.select(db.usuarios).get()) u.id: u};

    return DadosExportacao(
      focos: focos,
      observacoes: obs,
      manejos: manejos,
      midias: midias,
      usuarios: usuarios,
      de: filtro.de,
      ate: filtro.ate,
    );
  }
}
