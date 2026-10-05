import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/features/intro/intro_overlay.dart';

void main() {
  Widget app({bool reduzido = false, bool pronto = true}) => MaterialApp(
    home: const Scaffold(body: Text('App carregado')),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: reduzido),
      child: IntroOverlay(pronto: pronto, child: child!),
    ),
  );

  /// Avança o relógio em passos de frame (o ticker conta a partir do 1º frame).
  Future<void> avancar(WidgetTester tester, Duration d) async {
    for (var ms = 0; ms < d.inMilliseconds; ms += 16) {
      await tester.pump(const Duration(milliseconds: 16));
    }
  }

  testWidgets('roda, segura o último quadro por 2 s e revela o app', (tester) async {
    await tester.pumpWidget(app());
    expect(find.bySemanticsLabel(RegExp('Toque para pular')), findsOneWidget);
    await avancar(tester, const Duration(milliseconds: 4600)); // fim da animação
    expect(find.text('L'), findsOneWidget);
    await avancar(tester, const Duration(milliseconds: 1500)); // ainda na pausa
    expect(find.text('L'), findsOneWidget);
    await avancar(tester, const Duration(milliseconds: 1600)); // pausa + revelação
    await tester.pumpAndSettle();
    expect(find.text('L'), findsNothing);
    expect(find.text('App carregado'), findsOneWidget);
  });

  testWidgets('só revela quando o app estiver pronto', (tester) async {
    await tester.pumpWidget(app(pronto: false));
    await avancar(tester, const Duration(seconds: 9));
    expect(find.text('L'), findsOneWidget); // segura enquanto carrega
    await tester.pumpWidget(app(pronto: true));
    await avancar(tester, const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text('L'), findsNothing);
  });

  testWidgets('o app por baixo é montado uma vez só e não é recriado no fim', (tester) async {
    _ContaMontagens.montagens = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: const _ContaMontagens(),
        builder: (context, child) => IntroOverlay(child: child!),
      ),
    );
    await avancar(tester, const Duration(seconds: 9));
    await tester.pumpAndSettle();
    expect(find.byType(IntroOverlay), findsOneWidget);
    expect(find.text('L'), findsNothing); // abertura terminou
    expect(_ContaMontagens.montagens, 1);
  });

  testWidgets('toque pula para a revelação', (tester) async {
    await tester.pumpWidget(app());
    await avancar(tester, const Duration(milliseconds: 300));
    await tester.tap(find.byType(IntroOverlay));
    await avancar(tester, const Duration(milliseconds: 900));
    await tester.pumpAndSettle();
    expect(find.text('L'), findsNothing);
    expect(find.text('App carregado'), findsOneWidget);
  });

  testWidgets('movimento reduzido mostra a marca parada e some rápido', (tester) async {
    await tester.pumpWidget(app(reduzido: true));
    await tester.pump();
    expect(find.text('LUME'), findsOneWidget);
    await avancar(tester, const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
    expect(find.text('LUME'), findsNothing);
  });
}

class _ContaMontagens extends StatefulWidget {
  const _ContaMontagens();

  static int montagens = 0;

  @override
  State<_ContaMontagens> createState() => _ContaMontagensState();
}

class _ContaMontagensState extends State<_ContaMontagens> {
  @override
  void initState() {
    super.initState();
    _ContaMontagens.montagens++;
  }

  @override
  Widget build(BuildContext context) => const Text('App carregado');
}
