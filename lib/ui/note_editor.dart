import 'package:flutter/material.dart';

import '../model/note.dart';

/// Tamanho da área do editor de nota em 100%.
const Size editorSize = Size(340, 280);

// Centro do número e medidas da caixa.
const double _cx = 170;
const double _cy = 136;
const double _boxW = 84;
const double _boxH = 100;
const _move = Duration(milliseconds: 160);

/// A nota no centro, cercada pelas marcas que dá para colocar nela.
/// As marcas apagadas ficam esmaecidas; as acesas, na cor principal.
class NoteEditor extends StatelessWidget {
  const NoteEditor({
    super.key,
    required this.note,
    required this.onChanged,
    required this.onEnter,
    required this.keypadOpen,
    required this.onToggleKeypad,
  });

  final Note note;
  final ValueChanged<Note> onChanged;
  final VoidCallback onEnter;
  final bool keypadOpen;
  final VoidCallback onToggleKeypad;

  @override
  Widget build(BuildContext context) {
    final top = _cy - _boxH / 2;
    final bottom = _cy + _boxH / 2;
    final left = _cx - _boxW / 2;
    final right = _cx + _boxW / 2;
    final o = note.octave;
    final u = note.underlines;

    return SizedBox.fromSize(
      size: editorSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Teclado numérico (canto superior esquerdo).
          Positioned(
            left: 10,
            top: 10,
            child: IconButton.filledTonal(
              key: const Key('keypad-toggle'),
              tooltip: keypadOpen
                  ? 'Recolher teclado numérico'
                  : 'Abrir teclado numérico',
              isSelected: keypadOpen,
              onPressed: onToggleKeypad,
              icon: const Icon(Icons.dialpad),
            ),
          ),

          // Pontos de cima: o 1 fica perto do número, o 2 por fora.
          _mark(
            key: 'upper-dot-2',
            tip: 'Duas oitavas acima',
            center: Offset(_cx, top - 38),
            size: const Size(32, 22),
            onTap: () => onChanged(note.tapUpperDot(2)),
            child: _Dot(on: o == 2),
          ),
          _mark(
            key: 'upper-dot-1',
            tip: 'Uma oitava acima',
            center: Offset(_cx, top - 16),
            size: const Size(32, 22),
            onTap: () => onChanged(note.tapUpperDot(1)),
            child: _Dot(on: o >= 1),
          ),

          // Ligadura (canto superior direito do número).
          _mark(
            key: 'tie',
            tip: 'Ligadura com a próxima nota',
            center: Offset(right + 26, top - 18),
            size: const Size(48, 44),
            onTap: () => onChanged(note.tapTie()),
            child: _Tie(on: note.tie),
          ),

          // A caixa do número.
          Positioned(
            left: left,
            top: top,
            width: _boxW,
            height: _boxH,
            child: _NumberBox(
              digit: note.digit,
              onTap: keypadOpen ? null : onToggleKeypad,
            ),
          ),

          // Acidentes à esquerda: o escolhido desce/sobe para o meio.
          _mark(
            key: 'sharp',
            tip: 'Sustenido (#)',
            center: Offset(
              left - 22,
              note.accidental == Accidental.sharp ? _cy : _cy - 26,
            ),
            size: const Size(30, 30),
            animated: true,
            onTap: () => onChanged(note.tapSharp()),
            child: _Glyph('♯', on: note.accidental == Accidental.sharp),
          ),
          _mark(
            key: 'flat',
            tip: 'Bemol (b)',
            center: Offset(
              left - 22,
              note.accidental == Accidental.flat ? _cy : _cy + 26,
            ),
            size: const Size(30, 30),
            animated: true,
            onTap: () => onChanged(note.tapFlat()),
            child: _Glyph('♭', on: note.accidental == Accidental.flat),
          ),

          // À direita: traço (em cima) ou ponto (embaixo).
          _mark(
            key: 'dash',
            tip: 'Traço: mais um tempo',
            center: Offset(
              right + 22,
              note.side == SideMark.dash ? _cy : _cy - 26,
            ),
            size: const Size(32, 30),
            animated: true,
            onTap: () => onChanged(note.tapDash()),
            child: _Dash(on: note.side == SideMark.dash),
          ),
          _mark(
            key: 'dot',
            tip: 'Ponto: mais meio valor',
            center: Offset(
              right + 22,
              note.side == SideMark.dot ? _cy : _cy + 26,
            ),
            size: const Size(32, 30),
            animated: true,
            onTap: () => onChanged(note.tapDot()),
            child: _Dot(on: note.side == SideMark.dot),
          ),

          // Linhas de baixo: a de cima é a colcheia; a de baixo acende as duas.
          _mark(
            key: 'underline-1',
            tip: 'Uma linha: metade do tempo',
            center: Offset(_cx, bottom + 9),
            size: const Size(_boxW, 14),
            onTap: () => onChanged(note.tapUnderline(1)),
            child: _Underline(on: u >= 1),
          ),
          _mark(
            key: 'underline-2',
            tip: 'Duas linhas: um quarto do tempo',
            center: Offset(_cx, bottom + 23),
            size: const Size(_boxW, 14),
            onTap: () => onChanged(note.tapUnderline(2)),
            child: _Underline(on: u == 2),
          ),

          // Pontos de baixo, espelhados: o 1 perto das linhas, o 2 por fora.
          _mark(
            key: 'lower-dot-1',
            tip: 'Uma oitava abaixo',
            center: Offset(_cx, bottom + 44),
            size: const Size(32, 22),
            onTap: () => onChanged(note.tapLowerDot(1)),
            child: _Dot(on: o <= -1),
          ),
          _mark(
            key: 'lower-dot-2',
            tip: 'Duas oitavas abaixo',
            center: Offset(_cx, bottom + 66),
            size: const Size(32, 22),
            onTap: () => onChanged(note.tapLowerDot(2)),
            child: _Dot(on: o == -2),
          ),

          // Enter (canto inferior direito do número).
          Positioned(
            left: right + 16,
            top: bottom + 18,
            child: FilledButton(
              key: const Key('enter'),
              onPressed: note.isEmpty ? null : onEnter,
              style: FilledButton.styleFrom(
                minimumSize: const Size(72, 48),
                padding: EdgeInsets.zero,
              ),
              child: const Tooltip(
                message: 'Escrever a nota e limpar',
                child: Icon(Icons.keyboard_return, size: 26),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mark({
    required String key,
    required String tip,
    required Offset center,
    required Size size,
    required VoidCallback onTap,
    required Widget child,
    bool animated = false,
  }) {
    final content = Tooltip(
      message: tip,
      waitDuration: const Duration(milliseconds: 600),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          key: Key(key),
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Center(child: child),
        ),
      ),
    );
    final l = center.dx - size.width / 2;
    final t = center.dy - size.height / 2;
    return animated
        ? AnimatedPositioned(
            duration: _move,
            curve: Curves.easeOutCubic,
            left: l,
            top: t,
            width: size.width,
            height: size.height,
            child: content,
          )
        : Positioned(
            left: l,
            top: t,
            width: size.width,
            height: size.height,
            child: content,
          );
  }
}

Color _ink(BuildContext context, bool on) {
  final scheme = Theme.of(context).colorScheme;
  return on ? scheme.primary : scheme.onSurface.withValues(alpha: 0.2);
}

class _NumberBox extends StatelessWidget {
  const _NumberBox({required this.digit, required this.onTap});

  final int? digit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: onTap == null ? MouseCursor.defer : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Center(
            child: Text(
              digit?.toString() ?? '',
              key: const Key('digit'),
              style: TextStyle(
                fontSize: 68,
                height: 1,
                fontWeight: FontWeight.w500,
                color: digit == null
                    ? scheme.onSurface.withValues(alpha: 0.2)
                    : scheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Ponto; aceso ganha um anel em volta.
class _Dot extends StatelessWidget {
  const _Dot({required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) {
    final color = _ink(context, on);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: on ? color.withValues(alpha: 0.6) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

class _Underline extends StatelessWidget {
  const _Underline({required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) => Container(
    width: _boxW - 16,
    height: 3,
    decoration: BoxDecoration(
      color: _ink(context, on),
      borderRadius: BorderRadius.circular(2),
    ),
  );
}

class _Dash extends StatelessWidget {
  const _Dash({required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) => Container(
    width: 18,
    height: 3,
    decoration: BoxDecoration(
      color: _ink(context, on),
      borderRadius: BorderRadius.circular(2),
    ),
  );
}

class _Glyph extends StatelessWidget {
  const _Glyph(this.text, {required this.on});

  final String text;
  final bool on;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontSize: 24,
      height: 1,
      fontWeight: FontWeight.w600,
      fontFamilyFallback: const ['Segoe UI Symbol', 'Apple Symbols'],
      color: _ink(context, on),
    ),
  );
}

/// Um quarto de arco: firme perto do número, pontilhado na outra ponta.
class _Tie extends StatelessWidget {
  const _Tie({required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: const Size(40, 36),
    painter: _TiePainter(_ink(context, on)),
  );
}

class _TiePainter extends CustomPainter {
  _TiePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    // Arco de 90° com centro no canto inferior direito: começa embaixo à
    // esquerda (perto do número) e termina em cima à direita.
    final rect = Rect.fromCircle(
      center: Offset(size.width, size.height),
      radius: size.width - 4,
    );
    const start = 3.14159265; // 180°
    const sweep = 3.14159265 / 2;
    const solid = 0.5;
    canvas.drawArc(rect, start, sweep * solid, false, paint);
    // Metade final em pontos.
    const dots = 4;
    final dotPaint = Paint()..color = color;
    for (var i = 1; i <= dots; i++) {
      final a = start + sweep * (solid + (1 - solid) * i / dots);
      final p = rect.center + Offset.fromDirection(a, rect.width / 2);
      canvas.drawCircle(p, 1.4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_TiePainter old) => old.color != color;
}
