import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../model/note.dart';
import 'controls.dart';
import 'louvor.dart';

/// Tamanho da área do editor de nota em 100%.
const Size editorSize = Size(340, 280);

// Centro do número e medidas da caixa.
const double _cx = 170;
const double _cy = 136;
const double _boxW = 84;
const double _boxH = 100;
const _move = Duration(milliseconds: 200);

/// A nota no centro, cercada pelas marcas que dá para colocar nela.
/// Marca apagada em linha forte; acesa em tinta (Outline Selection Rule).
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
    final move = MediaQuery.of(context).disableAnimations
        ? Duration.zero
        : _move;

    Widget mark({
      required String key,
      required String tip,
      required Offset center,
      required Size size,
      required bool on,
      required VoidCallback onTap,
      required Widget Function(Color ink, bool on) draw,
      bool animated = false,
    }) {
      final rect = Rect.fromCenter(
        center: center,
        width: size.width,
        height: size.height,
      );
      final child = _Mark(
        key: Key(key),
        tip: tip,
        on: on,
        onTap: onTap,
        draw: draw,
      );
      return animated
          ? AnimatedPositioned.fromRect(
              duration: move,
              curve: louvorEase,
              rect: rect,
              child: child,
            )
          : Positioned.fromRect(rect: rect, child: child);
    }

    return SizedBox.fromSize(
      size: editorSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Teclado numérico (canto superior esquerdo).
          Positioned(
            left: 12,
            top: 12,
            child: LvButton(
              key: const Key('keypad-toggle'),
              tooltip: keypadOpen
                  ? 'Recolher teclado numérico'
                  : 'Abrir teclado numérico',
              pressionado: keypadOpen,
              width: 34,
              onPressed: onToggleKeypad,
              child: (fg) => LvIcon(Icone.teclado, color: fg),
            ),
          ),

          // Pontos de cima: o 1 fica perto do número, o 2 por fora.
          mark(
            key: 'upper-dot-2',
            tip: 'Duas oitavas acima',
            center: Offset(_cx, top - 38),
            size: const Size(32, 22),
            on: o == 2,
            onTap: () => onChanged(note.tapUpperDot(2)),
            draw: (ink, on) => _Dot(ink: ink, on: on),
          ),
          mark(
            key: 'upper-dot-1',
            tip: 'Uma oitava acima',
            center: Offset(_cx, top - 16),
            size: const Size(32, 22),
            on: o >= 1,
            onTap: () => onChanged(note.tapUpperDot(1)),
            draw: (ink, on) => _Dot(ink: ink, on: on),
          ),

          // Ligadura (canto superior direito do número).
          mark(
            key: 'tie',
            tip: 'Ligadura com a próxima nota',
            center: Offset(right + 26, top - 18),
            size: const Size(48, 44),
            on: note.tie,
            onTap: () => onChanged(note.tapTie()),
            draw: (ink, on) => CustomPaint(
              size: const Size(40, 36),
              painter: _TiePainter(ink, on),
            ),
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

          // Acidentes à esquerda: o escolhido vai para o meio.
          mark(
            key: 'sharp',
            tip: 'Sustenido',
            center: Offset(
              left - 22,
              note.accidental == Accidental.sharp ? _cy : _cy - 36,
            ),
            size: const Size(32, 40),
            on: note.accidental == Accidental.sharp,
            animated: true,
            onTap: () => onChanged(note.tapSharp()),
            draw: (ink, on) => Text('♯', style: musica(jpAcidente, ink)),
          ),
          mark(
            key: 'flat',
            tip: 'Bemol',
            center: Offset(
              left - 22,
              note.accidental == Accidental.flat ? _cy : _cy + 36,
            ),
            size: const Size(32, 40),
            on: note.accidental == Accidental.flat,
            animated: true,
            onTap: () => onChanged(note.tapFlat()),
            draw: (ink, on) => Text('♭', style: musica(jpAcidente, ink)),
          ),

          // À direita: traço (em cima) ou ponto (embaixo).
          mark(
            key: 'dash',
            tip: 'Traço: mais um tempo',
            center: Offset(
              right + 22,
              note.side == SideMark.dash ? _cy : _cy - 26,
            ),
            size: const Size(32, 30),
            on: note.side == SideMark.dash,
            animated: true,
            onTap: () => onChanged(note.tapDash()),
            draw: (ink, on) => _Bar(width: 18, ink: ink, on: on),
          ),
          mark(
            key: 'dot',
            tip: 'Ponto: mais meio valor',
            center: Offset(
              right + 22,
              note.side == SideMark.dot ? _cy : _cy + 26,
            ),
            size: const Size(32, 30),
            on: note.side == SideMark.dot,
            animated: true,
            onTap: () => onChanged(note.tapDot()),
            draw: (ink, on) => _Dot(ink: ink, on: on),
          ),

          // Linhas de baixo: a de cima é a colcheia; a de baixo acende as duas.
          mark(
            key: 'underline-1',
            tip: 'Uma linha: metade do tempo',
            center: Offset(_cx, bottom + 9),
            size: const Size(_boxW, 14),
            on: u >= 1,
            onTap: () => onChanged(note.tapUnderline(1)),
            draw: (ink, on) => _Bar(width: _boxW - 16, ink: ink, on: on),
          ),
          mark(
            key: 'underline-2',
            tip: 'Duas linhas: um quarto do tempo',
            center: Offset(_cx, bottom + 23),
            size: const Size(_boxW, 14),
            on: u == 2,
            onTap: () => onChanged(note.tapUnderline(2)),
            draw: (ink, on) => _Bar(width: _boxW - 16, ink: ink, on: on),
          ),

          // Pontos de baixo, espelhados: o 1 perto das linhas, o 2 por fora.
          mark(
            key: 'lower-dot-1',
            tip: 'Uma oitava abaixo',
            center: Offset(_cx, bottom + 44),
            size: const Size(32, 22),
            on: o <= -1,
            onTap: () => onChanged(note.tapLowerDot(1)),
            draw: (ink, on) => _Dot(ink: ink, on: on),
          ),
          mark(
            key: 'lower-dot-2',
            tip: 'Duas oitavas abaixo',
            center: Offset(_cx, bottom + 66),
            size: const Size(32, 22),
            on: o == -2,
            onTap: () => onChanged(note.tapLowerDot(2)),
            draw: (ink, on) => _Dot(ink: ink, on: on),
          ),

          // Enter (canto inferior direito do número).
          Positioned(
            left: right + 10,
            top: bottom + 22,
            child: LvButton(
              key: const Key('enter'),
              primario: true,
              tooltip: 'Escrever a nota no documento e limpar',
              onPressed: note.isEmpty ? null : onEnter,
              child: (fg) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Escrever', style: ui(t14, fg)),
                  const SizedBox(width: 8),
                  LvIcon(Icone.enter, color: fg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Uma marca clicável: apagada em linha forte, tinta-3 sob o mouse, acesa
/// em tinta.
class _Mark extends StatefulWidget {
  const _Mark({
    super.key,
    required this.tip,
    required this.on,
    required this.onTap,
    required this.draw,
  });

  final String tip;
  final bool on;
  final VoidCallback onTap;
  final Widget Function(Color ink, bool on) draw;

  @override
  State<_Mark> createState() => _MarkState();
}

class _MarkState extends State<_Mark> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = Louvor.of(context);
    final ink = widget.on ? c.tinta : (_hover ? c.tinta3 : c.linhaForte);
    return Semantics(
      button: true,
      toggled: widget.on,
      label: widget.tip,
      child: Tooltip(
        message: widget.tip,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
            child: Center(child: widget.draw(ink, widget.on)),
          ),
        ),
      ),
    );
  }
}

class _NumberBox extends StatelessWidget {
  const _NumberBox({required this.digit, required this.onTap});

  final int? digit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = Louvor.of(context);
    final digit = this.digit;
    return MouseRegion(
      cursor: onTap == null ? MouseCursor.defer : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: c.folha,
            borderRadius: BorderRadius.circular(rPadrao),
            border: Border.all(color: c.linhaForte),
          ),
          child: Center(
            child: digit == null
                ? Text(
                    '1–7\nou 0',
                    key: const Key('digit-empty'),
                    textAlign: TextAlign.center,
                    style: ui(t14, c.tinta3),
                  )
                : Text(
                    '$digit',
                    key: const Key('digit'),
                    style: mono(jpNota, c.tinta, peso: 500).copyWith(height: 1),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Ponto; aceso ganha um anel de tinta.
class _Dot extends StatelessWidget {
  const _Dot({required this.ink, required this.on});

  final Color ink;
  final bool on;

  @override
  Widget build(BuildContext context) => Container(
    width: 20,
    height: 20,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: on ? Border.all(color: ink, width: 1.5) : null,
    ),
    alignment: Alignment.center,
    child: Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: ink, shape: BoxShape.circle),
    ),
  );
}

/// Linha de duração ou traço: acesa também fica mais grossa.
class _Bar extends StatelessWidget {
  const _Bar({required this.width, required this.ink, required this.on});

  final double width;
  final Color ink;
  final bool on;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: on ? 3 : 2,
    decoration: BoxDecoration(
      color: ink,
      borderRadius: BorderRadius.circular(1.5),
    ),
  );
}

/// Um quarto de arco: firme perto do número, pontilhado na outra ponta.
class _TiePainter extends CustomPainter {
  _TiePainter(this.color, this.on);

  final Color color;
  final bool on;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = on ? 2.5 : 1.75
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    // Arco de 90° com centro no canto inferior direito: começa embaixo à
    // esquerda (perto do número) e termina em cima à direita.
    final rect = Rect.fromCircle(
      center: Offset(size.width, size.height),
      radius: size.width - 4,
    );
    const start = math.pi;
    const sweep = math.pi / 2;
    const solid = 0.5;
    canvas.drawArc(rect, start, sweep * solid, false, paint);
    const dots = 4;
    final dotPaint = Paint()..color = color;
    for (var i = 1; i <= dots; i++) {
      final a = start + sweep * (solid + (1 - solid) * i / dots);
      final p = rect.center + Offset.fromDirection(a, rect.width / 2);
      canvas.drawCircle(p, on ? 1.4 : 1.1, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_TiePainter old) => old.color != color || old.on != on;
}
