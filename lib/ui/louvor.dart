import 'package:flutter/material.dart';

/// Tokens do design_louvor v1.1.1 (`src/design_louvor/css/tokens.css`),
/// espelhados em Dart porque o app não usa CSS. Não redefinir aqui: mudança
/// de token é issue no repo design_louvor.
@immutable
class Louvor extends ThemeExtension<Louvor> {
  const Louvor({
    required this.papel,
    required this.papel2,
    required this.folha,
    required this.tinta,
    required this.tinta2,
    required this.tinta3,
    required this.linha,
    required this.linhaForte,
    required this.acao,
    required this.acao2,
    required this.foco,
  });

  static const claro = Louvor(
    papel: Color(0xFFF4F1EA),
    papel2: Color(0xFFEBE6DB),
    folha: Color(0xFFFBFAF6),
    tinta: Color(0xFF1B1F27),
    tinta2: Color(0xFF4A5160),
    tinta3: Color(0xFF5F6574),
    linha: Color(0xFFD9D3C5),
    linhaForte: Color(0xFFBFB7A6),
    acao: Color(0xFF1D2A44), // --noite
    acao2: Color(0xFF263556), // --noite-2
    foco: Color(0xFF3B6FD8),
  );

  static const escuro = Louvor(
    papel: Color(0xFF12161F),
    papel2: Color(0xFF1A1F2B),
    folha: Color(0xFF171C27),
    tinta: Color(0xFFECEBE6),
    tinta2: Color(0xFFB9BCC6),
    tinta3: Color(0xFF9097A6),
    linha: Color(0xFF2B3242),
    linhaForte: Color(0xFF3C4558),
    acao: Color(0xFF2F5BBF),
    acao2: Color(0xFF3768D4),
    foco: Color(0xFF3B6FD8),
  );

  final Color papel;
  final Color papel2;
  final Color folha;
  final Color tinta;
  final Color tinta2;
  final Color tinta3;
  final Color linha;
  final Color linhaForte;
  final Color acao;
  final Color acao2;
  final Color foco;

  static Louvor of(BuildContext context) =>
      Theme.of(context).extension<Louvor>() ?? claro;

  @override
  Louvor copyWith() => this;

  @override
  Louvor lerp(Louvor? other, double t) => t < 0.5 ? this : (other ?? this);
}

// Escala única (One Scale Rule).
const double t12 = 12;
const double t14 = 14;
const double t16 = 16;
const double t20 = 20;
const double t28 = 28;

/// Tamanho de leitura do número da nota: conteúdo musical, fora da escala
/// da interface (exceção do design_louvor para tamanhos de leitura).
const double jpNota = 64;

/// ♯ e ♭ ao lado do número, na mesma lógica de leitura.
const double jpAcidente = 30;

const double rPadrao = 4; // --r
const double rMedio = 8; // --r-m

/// `--ease`.
const Curve louvorEase = Cubic(0.16, 1, 0.3, 1);

const _fUi = 'Noto Sans';
const _fMono = 'Noto Sans Mono';
const _fMusica = 'Noto Music';

/// Texto da interface: 400 ou 650 (um só peso de destaque).
TextStyle ui(double size, Color color, {bool forte = false}) => TextStyle(
  fontFamily: _fUi,
  fontFamilyFallback: const [_fMusica],
  fontSize: size,
  fontWeight: forte ? FontWeight.w600 : FontWeight.w400,
  fontVariations: [FontVariation('wght', forte ? 650 : 400)],
  fontFeatures: const [FontFeature.tabularFigures()],
  color: color,
);

/// Números, códigos e o texto Jianpu ASCII.
TextStyle mono(double size, Color color, {double peso = 400}) => TextStyle(
  fontFamily: _fMono,
  fontFamilyFallback: const [_fUi, _fMusica],
  fontSize: size,
  fontVariations: [FontVariation('wght', peso)],
  color: color,
);

/// ♯ ♭ 𝄞 𝄢 e outros símbolos musicais.
TextStyle musica(double size, Color color) =>
    TextStyle(fontFamily: _fMusica, fontSize: size, height: 1, color: color);

ThemeData louvorTheme(Brightness brightness) {
  final c = brightness == Brightness.dark ? Louvor.escuro : Louvor.claro;
  final scheme = ColorScheme(
    brightness: brightness,
    primary: c.acao,
    onPrimary: Colors.white,
    secondary: c.tinta,
    onSecondary: c.papel,
    error: brightness == Brightness.dark
        ? const Color(0xFFF2776B)
        : const Color(0xFFB3261E),
    onError: Colors.white,
    surface: c.folha,
    onSurface: c.tinta,
    onSurfaceVariant: c.tinta2,
    outline: c.linhaForte,
    outlineVariant: c.linha,
    surfaceContainerHighest: c.papel2,
  );
  final hairline = BorderSide(color: c.linhaForte);
  return ThemeData(
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: c.papel,
    fontFamily: _fUi,
    fontFamilyFallback: const [_fMusica],
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    hoverColor: c.papel2,
    textSelectionTheme: TextSelectionThemeData(cursorColor: c.foco),
    extensions: [c],
    tooltipTheme: TooltipThemeData(
      waitDuration: const Duration(milliseconds: 600),
      textStyle: ui(t12, c.papel),
      decoration: BoxDecoration(
        color: c.tinta,
        borderRadius: BorderRadius.circular(rPadrao),
      ),
    ),
    // `.aviso`: plano, em folha com linha forte; sem sombra.
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      backgroundColor: c.folha,
      contentTextStyle: ui(t14, c.tinta),
      actionTextColor: c.tinta,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(rMedio),
        side: hairline,
      ),
    ),
    // O menu é o popover: a única sombra (`--sombra-pop`).
    popupMenuTheme: PopupMenuThemeData(
      color: c.folha,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(rMedio),
        side: BorderSide(color: c.linha),
      ),
    ),
  );
}
