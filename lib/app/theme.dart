import 'package:flutter/material.dart';

import '../domain/codigos.dart';

/// Cores da marca (lume-logo-kit) e cores funcionais do app.
abstract final class LumeCores {
  // Marca
  static const verdeFloresta = Color(0xFF38613F); // principal: botões, links, aba ativa, logotipo
  static const verdeNoite = Color(0xFF1E3824); // barra do registro (GPS), fundos escuros
  static const mentaClara = Color(0xFFADD7B5); // destaques, chips selecionados sobre escuro
  static const mentaEscura = Color(0xFF9CC599); // detalhes, ilustrações
  static const creme = Color(0xFFF7F4E5); // fundo de ícones e cabeçalhos

  // Superfícies e texto
  static const fundo = Color(0xFFFBFAF5);
  static const superficie = Color(0xFFFFFFFF);
  static const nevoa = Color(0xFFEEF4EF); // chips, cabeçalhos de cartão
  static const selecao = Color(0xFFDCEEDF); // item selecionado
  static const grafite = Color(0xFF16201A); // texto principal
  static const textoSecundario = Color(0xFF4A5650);
  static const borda = Color(0xFFD5DBD7);

  // Alertas
  static const laranjaAlerta = Color(0xFFE35205); // só focos detectados / detecção precoce
  static const laranjaTexto = Color(0xFFC2410C); // texto laranja sobre branco
  static const erro = Color(0xFFB42828);
  static const aviso = Color(0xFF8A5A00);
}

/// Forma do marcador de status (cor nunca é a única informação — RNF09).
enum FormaStatus { circulo, anel, triangulo, quadrado, quadradoCheck, circuloVazado }

class EstiloStatus {
  const EstiloStatus(this.cor, this.forma, this.rotulo);

  final Color cor;
  final FormaStatus forma;
  final String rotulo;

  static const _mapa = {
    StatusFoco.detectado: EstiloStatus(Color(0xFFE35205), FormaStatus.circulo, 'Detectado'),
    StatusFoco.emControle: EstiloStatus(Color(0xFF2C6BAA), FormaStatus.anel, 'Em controle'),
    StatusFoco.rebrotou: EstiloStatus(Color(0xFFB42828), FormaStatus.triangulo, 'Rebrotou'),
    StatusFoco.controlado: EstiloStatus(Color(0xFF5E9B52), FormaStatus.quadrado, 'Controlado'),
    StatusFoco.erradicado: EstiloStatus(LumeCores.verdeFloresta, FormaStatus.quadradoCheck, 'Erradicado'),
    StatusFoco.descartado: EstiloStatus(Color(0xFF8A958F), FormaStatus.circuloVazado, 'Descartado'),
  };

  static EstiloStatus de(String status) => _mapa[status] ?? _mapa[StatusFoco.detectado]!;
}

abstract final class LumeFontes {
  static const titulo = 'Archivo';
  static const texto = 'IBMPlexSans';
  static const mono = 'IBMPlexMono';
}

/// Estilo para coordenadas, precisão e dados.
TextStyle estiloMono({double tamanho = 14, Color? cor, FontWeight peso = FontWeight.w500}) =>
    TextStyle(fontFamily: LumeFontes.mono, fontSize: tamanho, color: cor, fontWeight: peso);

/// Estilo para códigos de foco (JAQ-0042) e títulos de marca.
TextStyle estiloCodigo({double tamanho = 16, Color? cor}) => TextStyle(
      fontFamily: LumeFontes.titulo,
      fontWeight: FontWeight.w800,
      fontSize: tamanho,
      color: cor ?? LumeCores.grafite,
      letterSpacing: 0.2,
    );

ThemeData temaLume() {
  final esquema = ColorScheme.fromSeed(
    seedColor: LumeCores.verdeFloresta,
    brightness: Brightness.light,
  ).copyWith(
    primary: LumeCores.verdeFloresta,
    onPrimary: Colors.white,
    primaryContainer: LumeCores.selecao,
    onPrimaryContainer: LumeCores.verdeNoite,
    secondary: LumeCores.mentaEscura,
    onSecondary: LumeCores.grafite,
    secondaryContainer: LumeCores.nevoa,
    onSecondaryContainer: LumeCores.verdeNoite,
    tertiary: LumeCores.laranjaAlerta,
    surface: LumeCores.superficie,
    onSurface: LumeCores.grafite,
    onSurfaceVariant: LumeCores.textoSecundario,
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: LumeCores.fundo,
    surfaceContainer: LumeCores.nevoa,
    surfaceContainerHigh: LumeCores.nevoa,
    outline: LumeCores.borda,
    outlineVariant: LumeCores.borda,
    error: LumeCores.erro,
  );

  const base = TextTheme();
  TextStyle t(double size, FontWeight w, {String family = LumeFontes.texto, double? h}) =>
      TextStyle(fontFamily: family, fontSize: size, fontWeight: w, color: LumeCores.grafite, height: h);

  final texto = base.copyWith(
    displaySmall: t(30, FontWeight.w800, family: LumeFontes.titulo),
    headlineMedium: t(26, FontWeight.w800, family: LumeFontes.titulo),
    headlineSmall: t(22, FontWeight.w800, family: LumeFontes.titulo),
    titleLarge: t(19, FontWeight.w700, family: LumeFontes.titulo),
    titleMedium: t(16, FontWeight.w600),
    titleSmall: t(14, FontWeight.w600),
    bodyLarge: t(16, FontWeight.w400, h: 1.4),
    bodyMedium: t(14, FontWeight.w400, h: 1.4),
    bodySmall: t(12.5, FontWeight.w400, h: 1.35).copyWith(color: LumeCores.textoSecundario),
    labelLarge: t(15, FontWeight.w600),
    labelMedium: t(13, FontWeight.w600),
    labelSmall: t(11.5, FontWeight.w600).copyWith(letterSpacing: 0.4),
  );

  const raio = BorderRadius.all(Radius.circular(12));
  const tamanhoBotao = Size(64, 52); // ≥ 48 dp (RNF03)

  return ThemeData(
    useMaterial3: true,
    colorScheme: esquema,
    fontFamily: LumeFontes.texto,
    textTheme: texto,
    scaffoldBackgroundColor: LumeCores.fundo,
    visualDensity: VisualDensity.standard,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    appBarTheme: AppBarTheme(
      backgroundColor: LumeCores.fundo,
      foregroundColor: LumeCores.grafite,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      centerTitle: false,
      titleTextStyle: texto.titleLarge,
    ),
    dividerTheme: const DividerThemeData(color: LumeCores.borda, thickness: 1, space: 1),
    cardTheme: const CardThemeData(
      color: LumeCores.superficie,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: raio,
        side: BorderSide(color: LumeCores.borda),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: tamanhoBotao,
        backgroundColor: LumeCores.verdeFloresta,
        foregroundColor: Colors.white,
        textStyle: texto.labelLarge,
        shape: const RoundedRectangleBorder(borderRadius: raio),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: tamanhoBotao,
        foregroundColor: LumeCores.verdeFloresta,
        side: const BorderSide(color: LumeCores.verdeFloresta, width: 1.5),
        textStyle: texto.labelLarge,
        shape: const RoundedRectangleBorder(borderRadius: raio),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        foregroundColor: LumeCores.verdeFloresta,
        textStyle: texto.labelLarge,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: LumeCores.superficie,
      selectedColor: LumeCores.selecao,
      side: const BorderSide(color: LumeCores.borda),
      labelStyle: texto.labelLarge!.copyWith(fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      checkmarkColor: LumeCores.verdeFloresta,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: LumeCores.superficie,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: raio,
        borderSide: const BorderSide(color: LumeCores.borda),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: raio,
        borderSide: const BorderSide(color: LumeCores.borda),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: raio,
        borderSide: const BorderSide(color: LumeCores.verdeFloresta, width: 2),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: LumeCores.superficie,
      indicatorColor: LumeCores.selecao,
      surfaceTintColor: Colors.transparent,
      height: 68,
      labelTextStyle: WidgetStateProperty.resolveWith((s) => texto.labelMedium!.copyWith(
            color: s.contains(WidgetState.selected) ? LumeCores.verdeFloresta : LumeCores.textoSecundario,
          )),
      iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
            color: s.contains(WidgetState.selected) ? LumeCores.verdeFloresta : LumeCores.textoSecundario,
          )),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: LumeCores.verdeNoite,
      contentTextStyle: texto.bodyMedium!.copyWith(color: Colors.white),
      actionTextColor: LumeCores.mentaClara,
    ),
    listTileTheme: ListTileThemeData(
      minVerticalPadding: 10,
      titleTextStyle: texto.titleMedium,
      subtitleTextStyle: texto.bodySmall,
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size(48, 48)),
        backgroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? LumeCores.selecao : LumeCores.superficie),
      ),
    ),
  );
}
