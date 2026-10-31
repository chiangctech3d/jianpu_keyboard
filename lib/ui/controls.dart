import 'package:flutter/material.dart';

import 'louvor.dart';

/// Ícones do app, desenhados em traço de 1,75 numa grade de 24 (`.ico`).
enum Icone { teclado, enter, apagar, abaixo }

class LvIcon extends StatelessWidget {
  const LvIcon(this.icone, {super.key, required this.color, this.size = 18});

  final Icone icone;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _IconPainter(icone, color));
}

class _IconPainter extends CustomPainter {
  _IconPainter(this.icone, this.color);

  final Icone icone;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24);
    final traco = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.75
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final cheio = Paint()..color = color;
    switch (icone) {
      case Icone.teclado:
        for (final y in [4.5, 10.0, 15.5]) {
          for (final x in [6.0, 12.0, 18.0]) {
            canvas.drawCircle(Offset(x, y), 1.6, cheio);
          }
        }
        canvas.drawCircle(const Offset(12, 21), 1.6, cheio);
      case Icone.enter:
        canvas.drawPath(
          Path()
            ..moveTo(20, 5)
            ..lineTo(20, 11)
            ..arcToPoint(const Offset(16, 15), radius: const Radius.circular(4))
            ..lineTo(5, 15),
          traco,
        );
        canvas.drawPath(
          Path()
            ..moveTo(9, 11)
            ..lineTo(5, 15)
            ..lineTo(9, 19),
          traco,
        );
      case Icone.abaixo:
        canvas.drawPath(
          Path()
            ..moveTo(6, 9)
            ..lineTo(12, 15)
            ..lineTo(18, 9),
          traco,
        );
      case Icone.apagar:
        canvas.drawPath(
          Path()
            ..moveTo(9, 5)
            ..lineTo(19, 5)
            ..arcToPoint(const Offset(21, 7), radius: const Radius.circular(2))
            ..lineTo(21, 17)
            ..arcToPoint(const Offset(19, 19), radius: const Radius.circular(2))
            ..lineTo(9, 19)
            ..lineTo(3, 12)
            ..close(),
          traco,
        );
        canvas.drawLine(const Offset(12, 9.5), const Offset(17, 14.5), traco);
        canvas.drawLine(const Offset(17, 9.5), const Offset(12, 14.5), traco);
    }
  }

  @override
  bool shouldRepaint(_IconPainter old) =>
      old.icone != icone || old.color != color;
}

/// Botão do design_louvor (`.btn`): folha com linha forte; `primario` em
/// `--acao`; `pressionado` inverte para tinta (`aria-pressed`).
class LvButton extends StatefulWidget {
  const LvButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.tooltip,
    this.primario = false,
    this.pressionado,
    this.width,
    this.height = 34,
  });

  final VoidCallback? onPressed;

  /// Recebe a cor do texto/ícone.
  final Widget Function(Color fg) child;
  final String? tooltip;
  final bool primario;

  /// `null` quando o botão não alterna.
  final bool? pressionado;
  final double? width;
  final double height;

  @override
  State<LvButton> createState() => _LvButtonState();
}

class _LvButtonState extends State<LvButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = Louvor.of(context);
    final enabled = widget.onPressed != null;
    final hover = _hover && enabled;
    final Color bg;
    final Color fg;
    final Color border;
    if (widget.primario) {
      bg = hover ? c.acao2 : c.acao;
      fg = Colors.white;
      border = bg;
    } else if (widget.pressionado ?? false) {
      bg = c.tinta;
      fg = c.papel;
      border = c.tinta;
    } else {
      bg = c.folha;
      fg = c.tinta;
      border = hover ? c.tinta3 : c.linhaForte;
    }
    Widget button = MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Opacity(
          opacity: enabled ? 1 : 0.5,
          child: Container(
            width: widget.width,
            height: widget.height,
            padding: widget.width == null
                ? const EdgeInsets.symmetric(horizontal: 12)
                : null,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(rPadrao),
              border: Border.all(color: border),
            ),
            child: widget.child(fg),
          ),
        ),
      ),
    );
    if (widget.tooltip case final tip?) {
      button = Tooltip(message: tip, child: button);
    }
    return Semantics(
      button: true,
      enabled: enabled,
      toggled: widget.pressionado,
      label: widget.tooltip,
      child: button,
    );
  }
}
