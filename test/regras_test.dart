import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/geo.dart';
import 'package:lume/domain/codigos.dart';
import 'package:lume/domain/regras.dart';

void main() {
  const cfg = RegrasConfig();
  final t0 = DateTime.utc(2026, 1, 10);
  EventoFoco det(DateTime d) => EventoFoco(tipo: TipoEvento.deteccao, data: d, presenca: Presenca.presente);
  EventoFoco man(DateTime d) => EventoFoco(tipo: TipoEvento.manejo, data: d);
  EventoFoco aus(DateTime d) =>
      EventoFoco(tipo: TipoEvento.revisita, data: d, presenca: Presenca.ausente, resultado: ResultadoRevisita.ausente);
  EventoFoco pres(DateTime d, [String? r]) =>
      EventoFoco(tipo: TipoEvento.revisita, data: d, presenca: Presenca.presente, resultado: r);

  group('Status do foco (RN09–RN13)', () {
    test('RN09: detecção → detectado', () {
      expect(calcularStatus([det(t0)], cfg), StatusFoco.detectado);
    });

    test('RN10: manejo → em controle', () {
      expect(calcularStatus([det(t0), man(t0.add(const Duration(days: 1)))], cfg), StatusFoco.emControle);
    });

    test('revisita presente em foco em controle mantém em controle', () {
      expect(calcularStatus([det(t0), man(t0.add(const Duration(days: 1))), pres(t0.add(const Duration(days: 30)))], cfg),
          StatusFoco.emControle);
    });

    test('RN11: revisita ausente → controlado', () {
      expect(calcularStatus([det(t0), man(t0.add(const Duration(days: 1))), aus(t0.add(const Duration(days: 30)))], cfg),
          StatusFoco.controlado);
    });

    test('RN12: resultado rebrota → rebrotou', () {
      expect(
          calcularStatus(
              [det(t0), man(t0.add(const Duration(days: 1))), pres(t0.add(const Duration(days: 30)), ResultadoRevisita.rebrota)],
              cfg),
          StatusFoco.rebrotou);
    });

    test('RN12: presente depois de controlado → rebrotou; novo manejo → em controle', () {
      final ev = [det(t0), man(t0.add(const Duration(days: 1))), aus(t0.add(const Duration(days: 30))), pres(t0.add(const Duration(days: 60)))];
      expect(calcularStatus(ev, cfg), StatusFoco.rebrotou);
      expect(calcularStatus([...ev, man(t0.add(const Duration(days: 61)))], cfg), StatusFoco.emControle);
    });

    test('ordem dos eventos não importa', () {
      final ev = [aus(t0.add(const Duration(days: 30))), det(t0), man(t0.add(const Duration(days: 1)))];
      expect(calcularStatus(ev, cfg), StatusFoco.controlado);
    });

    test('RN13: 3 ausências seguidas cobrindo 12 meses → erradicado', () {
      final m = t0.add(const Duration(days: 1));
      final ev = [
        det(t0),
        man(m),
        aus(DateTime.utc(2026, 4, 1)),
        aus(DateTime.utc(2026, 9, 1)),
        aus(DateTime.utc(2027, 1, 15)),
      ];
      expect(calcularStatus(ev, cfg), StatusFoco.erradicado);
    });

    test('RN13: 3 ausências em menos de 12 meses → ainda controlado', () {
      final ev = [
        det(t0),
        man(t0.add(const Duration(days: 1))),
        aus(DateTime.utc(2026, 3, 1)),
        aus(DateTime.utc(2026, 5, 1)),
        aus(DateTime.utc(2026, 8, 1)),
      ];
      expect(calcularStatus(ev, cfg), StatusFoco.controlado);
    });

    test('RN13: presença no meio zera a sequência', () {
      final ev = [
        det(t0),
        man(t0.add(const Duration(days: 1))),
        aus(DateTime.utc(2026, 4, 1)),
        aus(DateTime.utc(2026, 9, 1)),
        pres(DateTime.utc(2026, 10, 1)),
        aus(DateTime.utc(2027, 1, 15)),
        aus(DateTime.utc(2027, 2, 15)),
      ];
      expect(calcularStatus(ev, cfg), StatusFoco.controlado);
    });
  });

  group('Geometria', () {
    test('distância de 1 milésimo de grau de latitude ≈ 111 m', () {
      final d = distanciaM(const GeoPonto(-20.745, -41.291), const GeoPonto(-20.746, -41.291));
      expect(d, closeTo(110.6, 1));
    });

    test('rumo para o norte ≈ 0° e para o leste ≈ 90°', () {
      const a = GeoPonto(-20.745, -41.291);
      expect(rumoGraus(a, const GeoPonto(-20.744, -41.291)), closeTo(0, 0.5));
      expect(rumoGraus(a, const GeoPonto(-20.745, -41.290)), closeTo(90, 0.5));
    });

    test('ponto no polígono', () {
      const quadrado = [GeoPonto(0, 0), GeoPonto(0, 1), GeoPonto(1, 1), GeoPonto(1, 0)];
      expect(pontoNoPoligono(const GeoPonto(0.5, 0.5), quadrado), isTrue);
      expect(pontoNoPoligono(const GeoPonto(1.5, 0.5), quadrado), isFalse);
    });
  });

  group('Foco próximo (RN07)', () {
    const aqui = GeoPonto(-20.7450, -41.2910);
    final focos = [
      const FocoResumo(id: 'a', especieId: 'jaq', ponto: GeoPonto(-20.74510, -41.2910), status: StatusFoco.detectado), // ~11 m
      const FocoResumo(id: 'b', especieId: 'jaq', ponto: GeoPonto(-20.74540, -41.2910), status: StatusFoco.detectado), // ~44 m
      const FocoResumo(id: 'c', especieId: 'aca', ponto: GeoPonto(-20.74505, -41.2910), status: StatusFoco.detectado),
      const FocoResumo(id: 'd', especieId: 'jaq', ponto: GeoPonto(-20.74505, -41.2910), status: StatusFoco.descartado),
    ];

    test('só mesma espécie, não descartado, dentro de 20 m + precisão', () {
      final r = focosProximosMesmaEspecie(especieId: 'jaq', ponto: aqui, precisaoM: 5, focos: focos, cfg: cfg);
      expect(r.map((e) => e.$1.id), ['a']);
    });

    test('precisão maior amplia o raio', () {
      final r = focosProximosMesmaEspecie(especieId: 'jaq', ponto: aqui, precisaoM: 30, focos: focos, cfg: cfg);
      expect(r.map((e) => e.$1.id), ['a', 'b']);
    });

    test('"outra espécie" nunca casa', () {
      expect(focosProximosMesmaEspecie(especieId: especieOutra, ponto: aqui, precisaoM: 50, focos: focos, cfg: cfg), isEmpty);
    });
  });

  group('Detecção precoce (RN15)', () {
    const aqui = GeoPonto(-20.7450, -41.2910);

    test('espécie "outra" é precoce', () {
      final m = motivosDeteccaoPrecoce(especieId: especieOutra, ponto: aqui, focosExistentes: const [], cfg: cfg, nIndividuos: 50);
      expect(m, contains('Possível espécie nova na Flona'));
    });

    test('primeira ocorrência da espécie é precoce', () {
      final m = motivosDeteccaoPrecoce(especieId: 'jaq', ponto: aqui, focosExistentes: const [], cfg: cfg, nIndividuos: 50);
      expect(m, ['Primeira ocorrência da espécie na Flona']);
    });

    test('a mais de 200 m de foco ativo é nova frente; perto não é', () {
      const longe = FocoResumo(id: 'x', especieId: 'jaq', ponto: GeoPonto(-20.7500, -41.2910), status: StatusFoco.detectado);
      const perto = FocoResumo(id: 'y', especieId: 'jaq', ponto: GeoPonto(-20.7455, -41.2910), status: StatusFoco.emControle);
      expect(motivosDeteccaoPrecoce(especieId: 'jaq', ponto: aqui, focosExistentes: const [longe], cfg: cfg, nIndividuos: 50),
          hasLength(1));
      expect(motivosDeteccaoPrecoce(especieId: 'jaq', ponto: aqui, focosExistentes: const [longe, perto], cfg: cfg, nIndividuos: 50),
          isEmpty);
    });

    test('abundância pequena é precoce', () {
      const perto = FocoResumo(id: 'y', especieId: 'jaq', ponto: GeoPonto(-20.7455, -41.2910), status: StatusFoco.emControle);
      expect(motivosDeteccaoPrecoce(especieId: 'jaq', ponto: aqui, focosExistentes: const [perto], cfg: cfg, nIndividuos: 3),
          ['Abundância pequena']);
      expect(motivosDeteccaoPrecoce(especieId: 'jaq', ponto: aqui, focosExistentes: const [perto], cfg: cfg, classeAbundancia: 'c2'),
          ['Abundância pequena']);
      expect(motivosDeteccaoPrecoce(especieId: 'jaq', ponto: aqui, focosExistentes: const [perto], cfg: cfg, areaM2: 8),
          ['Abundância pequena']);
    });
  });

  group('Validações', () {
    test('RN20: métodos químicos exigem herbicida', () {
      expect(manejoExigeHerbicida('corte_herbicida'), isTrue);
      expect(manejoExigeHerbicida('arranquio'), isFalse);
    });

    test('RN22: autor edita por 24 h; gestor sempre', () {
      final criado = DateTime.utc(2026, 10, 1, 8);
      expect(podeEditar(perfil: Perfil.campo, autorId: 'u', usuarioId: 'u', criadoEm: criado, agora: criado.add(const Duration(hours: 23))), isTrue);
      expect(podeEditar(perfil: Perfil.campo, autorId: 'u', usuarioId: 'u', criadoEm: criado, agora: criado.add(const Duration(hours: 25))), isFalse);
      expect(podeEditar(perfil: Perfil.campo, autorId: 'u', usuarioId: 'v', criadoEm: criado, agora: criado), isFalse);
      expect(podeEditar(perfil: Perfil.gestor, autorId: 'u', usuarioId: 'v', criadoEm: criado, agora: criado.add(const Duration(days: 9))), isTrue);
    });
  });
}
