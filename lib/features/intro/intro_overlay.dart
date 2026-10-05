import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme.dart';
import 'intro_painter.dart';

/// Abertura do Lume: vaga-lumes na floresta noturna se juntam e acendem o
/// marcador do mapa; a luz se abre e revela o app que já carregou por baixo.
///
/// Começa no primeiro frame do app, enquanto o banco inicializa por baixo.
/// Ao terminar, a marca fica parada por [pausaFinal]; a revelação só acontece
/// quando [pronto] for verdadeiro. Toque pula para a revelação.
/// Com "remover animações" ativo no aparelho, faz só um fade curto.
class IntroOverlay extends StatefulWidget {
  const IntroOverlay({
    super.key,
    required this.child,
    this.pronto = true,
    this.duracao = const Duration(milliseconds: 5200),
    this.pausaFinal = const Duration(seconds: 2),
  });

  final Widget child;
  final bool pronto;
  final Duration duracao;
  final Duration pausaFinal;

  @override
  State<IntroOverlay> createState() => _IntroOverlayState();
}

class _IntroOverlayState extends State<IntroOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: widget.duracao);
  bool _terminou = false;
  bool _vibrou = false;
  bool _reduzido = false;
  bool _iniciado = false;
  bool _pausaFeita = false;
  bool _revelando = false;
  Timer? _pausa;

  /// O app por baixo só é montado na pausa final: montar rotas, Início e mapa
  /// no meio da animação causava travadas.
  bool _montarApp = false;

  final _chaveApp = GlobalKey(debugLabel: 'app');
  late final ui.Image _sprite = criarSpriteBrilho();
  CenaIntro? _cena;

  /// Onde a animação para e segura antes da revelação.
  double get _fimIntro => _reduzido ? 0.6 : FasesIntro.revelar.begin;

  // Geometria calculada para o tamanho da tela.
  Size? _tamanho;
  late Offset _centro;
  late double _larguraMarcador;

  @override
  void initState() {
    super.initState();
    // Carrega o SVG do marcador já no início, para não travar quando ele aparece.
    const marcador = SvgAssetLoader('assets/branding/lume-marcador.svg');
    svg.cache.putIfAbsent(marcador.cacheKey(null), () => marcador.loadBytes(null));
    _c.addListener(_aoAvancar);
    _c.addStatusListener((s) {
      // animateTo para frente também termina como "completed"; só encerra no fim real.
      if (s == AnimationStatus.completed && _c.value >= 1) _finalizar();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_iniciado) return;
    _iniciado = true;
    _reduzido = MediaQuery.of(context).disableAnimations;
    if (_reduzido) {
      // Movimento reduzido: mostra a marca parada e some com fade.
      _c.duration = const Duration(milliseconds: 900);
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) _c.animateTo(_fimIntro).then((_) => _segurar());
    });
  }

  @override
  void didUpdateWidget(IntroOverlay old) {
    super.didUpdateWidget(old);
    if (widget.pronto && !old.pronto) _tentarRevelar();
  }

  /// Último quadro parado por um instante antes de abrir para o app.
  void _segurar() {
    _pausa?.cancel();
    if (!_montarApp) setState(() => _montarApp = true);
    _pausa = Timer(_reduzido ? const Duration(milliseconds: 300) : widget.pausaFinal, () {
      _pausaFeita = true;
      _tentarRevelar();
    });
  }

  void _tentarRevelar() {
    if (!mounted || _revelando || !_pausaFeita || !widget.pronto) return;
    _revelando = true;
    _c.animateTo(1);
  }

  void _aoAvancar() {
    if (!_vibrou && !_reduzido && _c.value >= FasesIntro.instanteVibracao) {
      _vibrou = true;
      HapticFeedback.lightImpact();
    }
  }

  void _pular() {
    if (_terminou || _revelando) return;
    _pausa?.cancel();
    if (_c.value < _fimIntro) _c.value = _fimIntro;
    _pausaFeita = true;
    if (!_montarApp) setState(() => _montarApp = true);
    _tentarRevelar(); // se o app ainda não carregou, revela assim que ficar pronto
  }

  void _finalizar() {
    if (_terminou) return;
    setState(() => _terminou = true);
  }

  void _prepararGeometria(Size s) {
    if (_tamanho == s) return;
    _tamanho = s;
    _larguraMarcador = math.min(s.width * 0.28, 132);
    _centro = Offset(s.width / 2, s.height * 0.40);
    final contorno = contornoMarcador(_centro, _larguraMarcador);
    final r = math.Random(2026);
    _cena = CenaIntro(
      vagalumes: [for (final a in amostrar(contorno, 46)) Vagalume(r, a)],
      contorno: contorno,
      centroMarcador: _centro,
      floresta: gerarFloresta(s),
      sprite: _sprite,
      tamanho: s,
    );
  }

  @override
  void dispose() {
    _pausa?.cancel();
    _c.dispose();
    _sprite.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // A estrutura da árvore não muda quando a abertura termina: o app fica
    // sempre na mesma posição (com chave global) e só a camada de cima sai.
    // Se o app trocasse de lugar, o Flutter o recriaria do zero no fim do círculo.
    return Stack(
      children: [
        KeyedSubtree(
          key: _chaveApp,
          child: _montarApp ? widget.child : const ColoredBox(color: LumeCores.verdeNoite, child: SizedBox.expand()),
        ),
        if (!_terminou)
          Positioned.fill(
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _pular,
                child: Semantics(
                  label: 'Lume. Ilumine o que ameaça a floresta. Toque para pular a abertura.',
                  button: true,
                  // Fica acima do Navigator: precisa do próprio Material para o texto.
                  child: Material(
                    type: MaterialType.transparency,
                    child: _reduzido ? _versaoReduzida() : _versaoCompleta(),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _versaoReduzida() => FadeTransition(
    opacity: ReverseAnimation(CurvedAnimation(parent: _c, curve: const Interval(0.6, 1))),
    child: const ColoredBox(
      color: LumeCores.creme,
      child: Center(child: _Marca(mostrarSlogan: true, cor: LumeCores.verdeFloresta)),
    ),
  );

  Widget _versaoCompleta() => LayoutBuilder(
    builder: (context, box) {
      final size = box.biggest;
      _prepararGeometria(size);
      return AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final t = _c.value;
          final revelar = FasesIntro.revelar.transform(t);
          final pintor = PintorIntro(t: t, segundos: t * widget.duracao.inMilliseconds / 1000, cena: _cena!);
          final cena = Stack(
            children: [
              Positioned.fill(
                child: RepaintBoundary(child: CustomPaint(painter: pintor)),
              ),
              _marcador(t),
              _texto(t, size),
            ],
          );
          if (revelar <= 0) return cena;
          // Revelação: um furo circular que cresce a partir do marcador.
          final raio = raioRevelacao(size, _centro, revelar);
          return Stack(
            children: [
              ClipPath(clipper: _FuroCircular(_centro, raio), child: cena),
              IgnorePointer(
                child: CustomPaint(size: size, painter: PintorAnelRevelacao(_centro, raio, revelar)),
              ),
            ],
          );
        },
      );
    },
  );

  Widget _marcador(double t) {
    final entrada = FasesIntro.marcador.transform(t);
    final alturaMarcador = _larguraMarcador * 270 / 197;
    return Positioned(
      left: _centro.dx - _larguraMarcador / 2,
      top: _centro.dy - alturaMarcador / 2,
      width: _larguraMarcador,
      height: alturaMarcador,
      child: Opacity(
        opacity: Curves.easeOut.transform(const Interval(0.58, 0.66).transform(t)),
        child: Transform.scale(
          scale: 0.55 + 0.45 * entrada,
          alignment: Alignment.bottomCenter,
          child: SvgPicture.asset('assets/branding/lume-marcador.svg', fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _texto(double t, Size size) {
    final topo = _centro.dy + _larguraMarcador * 270 / 197 / 2 + 34;
    final slogan = FasesIntro.slogan.transform(t);
    const letras = ['L', 'U', 'M', 'E'];
    return Positioned(
      left: 0,
      right: 0,
      top: topo,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < letras.length; i++)
                Builder(
                  builder: (_) {
                    // Cada letra entra um pouco depois da anterior.
                    final ini = FasesIntro.letras.begin + i * 0.025;
                    final p = Curves.easeOutBack.transform(Interval(ini, ini + 0.07).transform(t));
                    return Opacity(
                      opacity: p.clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(0, 18 * (1 - p)),
                        child: Text(
                          letras[i],
                          style: TextStyle(
                            fontFamily: LumeFontes.titulo,
                            fontWeight: FontWeight.w800,
                            fontSize: 46,
                            height: 1,
                            letterSpacing: 4 + 10 * (1 - p),
                            color: Colors.white,
                            shadows: [Shadow(color: LumeCores.mentaClara.withValues(alpha: 0.6 * p), blurRadius: 18)],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 12),
          Opacity(
            opacity: slogan,
            child: Transform.translate(
              offset: Offset(0, 8 * (1 - slogan)),
              child: Text(
                'Ilumine o que ameaça a floresta.',
                style: TextStyle(
                  fontFamily: LumeFontes.texto,
                  fontSize: 15,
                  letterSpacing: 0.3,
                  color: LumeCores.mentaClara.withValues(alpha: 0.95),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Retângulo inteiro menos um círculo (a "janela de luz" que revela o app).
class _FuroCircular extends CustomClipper<Path> {
  _FuroCircular(this.centro, this.raio);

  final Offset centro;
  final double raio;

  @override
  Path getClip(Size size) => Path()
    ..fillType = PathFillType.evenOdd
    ..addRect(Offset.zero & size)
    ..addOval(Rect.fromCircle(center: centro, radius: raio));

  @override
  bool shouldReclip(_FuroCircular old) => old.raio != raio || old.centro != centro;
}

/// Marca estática (versão de movimento reduzido).
class _Marca extends StatelessWidget {
  const _Marca({required this.mostrarSlogan, required this.cor});

  final bool mostrarSlogan;
  final Color cor;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SvgPicture.asset('assets/branding/lume-marcador.svg', height: 140),
      const SizedBox(height: 24),
      Text(
        'LUME',
        style: TextStyle(
          fontFamily: LumeFontes.titulo,
          fontWeight: FontWeight.w800,
          fontSize: 44,
          letterSpacing: 4,
          color: cor,
        ),
      ),
      if (mostrarSlogan) ...[
        const SizedBox(height: 8),
        Text(
          'Ilumine o que ameaça a floresta.',
          style: TextStyle(fontFamily: LumeFontes.texto, fontSize: 15, color: cor),
        ),
      ],
    ],
  );
}
