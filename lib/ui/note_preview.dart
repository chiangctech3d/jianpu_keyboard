import 'package:flutter/material.dart';

import '../model/encoding.dart';
import '../model/note.dart';
import '../model/pitch.dart';

/// Tamanho do painel de baixo em 100%.
const Size previewSize = Size(340, 104);

/// Canto inferior esquerdo: o tom, a nota na pauta e o que ela é.
class NotePreview extends StatelessWidget {
  const NotePreview({
    super.key,
    required this.note,
    required this.musicKey,
    required this.onKeyChanged,
  });

  final Note note;
  final MusicKey musicKey;
  final ValueChanged<MusicKey> onKeyChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final pitch = pitchOf(note, musicKey);
    final rest = note.digit == 0;
    final beats = beatsOf(note);
    final text = toJianpuAscii(note);

    return SizedBox.fromSize(
      size: previewSize,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Tom: o que vale o "1".
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tom', style: theme.textTheme.labelSmall),
                Row(
                  children: [
                    Text('1 = ', style: theme.textTheme.titleMedium),
                    DropdownButton<MusicKey>(
                      key: const Key('key-select'),
                      value: musicKey,
                      isDense: true,
                      underline: const SizedBox.shrink(),
                      focusColor: Colors.transparent,
                      style: theme.textTheme.titleMedium,
                      items: [
                        for (final k in musicKeys)
                          DropdownMenuItem(value: k, child: Text(k.label)),
                      ],
                      onChanged: (k) {
                        if (k != null) onKeyChanged(k);
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 96,
              height: 90,
              child: CustomPaint(
                painter: StaffPainter(
                  pitch: note.isEmpty || rest ? null : pitch,
                  flags: note.underlines,
                  hollow: note.side == SideMark.dash && note.underlines == 0,
                  dotted: note.side == SideMark.dot,
                  color: theme.colorScheme.onSurface,
                  lineColor: muted.withValues(alpha: 0.6),
                ),
                child: rest
                    ? Center(
                        child: Text(
                          'pausa',
                          style: theme.textTheme.labelMedium,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              // Encolhe o texto em vez de quebrar a linha.
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (note.isEmpty)
                      Text(
                        'Escolha um número',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: muted,
                        ),
                      )
                    else ...[
                      Text(
                        rest ? 'Pausa' : '${pitch!.name}  ${pitch.solfege}',
                        key: const Key('pitch-name'),
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        durationName(note) ?? 'duração livre',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        beatsLabel(beats),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: muted,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        text,
                        key: const Key('ascii'),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                          fontFamilyFallback: const ['Consolas', 'Menlo'],
                          color: muted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pauta de cinco linhas com a nota. Usa clave de sol; abaixo do dó
/// central, clave de fá.
class StaffPainter extends CustomPainter {
  StaffPainter({
    required this.pitch,
    required this.flags,
    required this.hollow,
    required this.dotted,
    required this.color,
    required this.lineColor,
  });

  final Pitch? pitch;

  /// Bandeirolas: uma por linha embaixo do número.
  final int flags;

  /// Cabeça vazada (mínima).
  final bool hollow;
  final bool dotted;
  final Color color;
  final Color lineColor;

  static const _gap = 8.0; // distância entre linhas
  static const _c4Step = 28; // C4 em degraus a partir de C0

  @override
  void paint(Canvas canvas, Size size) {
    final pitch = this.pitch;
    final bass = pitch != null && pitch.step < _c4Step;
    // Degrau da linha de baixo: E4 (sol) ou G2 (fá).
    final bottomStep = bass ? 18 : 30;
    final bottomY = size.height / 2 + 2 * _gap;
    double yOf(int step) => bottomY - (step - bottomStep) * _gap / 2;

    final line = Paint()
      ..color = lineColor
      ..strokeWidth = 1;
    for (var i = 0; i < 5; i++) {
      final y = bottomY - i * _gap;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }

    _text(
      canvas,
      bass ? '𝄢' : '𝄞',
      Offset(2, bass ? bottomY - 4.4 * _gap : bottomY - 5.6 * _gap),
      bass ? 30 : 42,
      color,
    );

    if (pitch == null) return;
    final x = size.width * 0.68;
    final y = yOf(pitch.step);
    final rel = pitch.step - bottomStep;

    // Linhas suplementares.
    for (var s = -2; s >= rel; s -= 2) {
      final ly = yOf(bottomStep + s);
      canvas.drawLine(Offset(x - 10, ly), Offset(x + 10, ly), line);
    }
    for (var s = 10; s <= rel; s += 2) {
      final ly = yOf(bottomStep + s);
      canvas.drawLine(Offset(x - 10, ly), Offset(x + 10, ly), line);
    }

    if (pitch.accidentalSign.isNotEmpty) {
      _text(canvas, pitch.accidentalSign, Offset(x - 22, y - 11), 16, color);
    }

    final head = Paint()
      ..color = color
      ..style = hollow ? PaintingStyle.stroke : PaintingStyle.fill
      ..strokeWidth = 1.6;
    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(-0.35);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 10.5, height: 7.5),
      head,
    );
    canvas.restore();

    // Haste para cima abaixo da linha do meio, para baixo acima dela.
    final up = rel < 4;
    final stem = Paint()
      ..color = color
      ..strokeWidth = 1.3;
    final sx = up ? x + 4.8 : x - 4.8;
    final tipY = up ? y - 3.5 * _gap : y + 3.5 * _gap;
    canvas.drawLine(Offset(sx, y), Offset(sx, tipY), stem);

    // Bandeirolas: colcheia 1, semicolcheia 2.
    final flag = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < flags; i++) {
      final fy = tipY + (up ? i * 6.0 : -i * 6.0);
      final path = Path()
        ..moveTo(sx, fy)
        ..quadraticBezierTo(
          sx + 9,
          fy + (up ? 6 : -6),
          sx + 7,
          fy + (up ? 14 : -14),
        );
      canvas.drawPath(path, flag);
    }

    // Ponto de aumento, sempre num espaço.
    if (dotted) {
      final dy = rel.isEven ? y - _gap / 2 : y;
      canvas.drawCircle(Offset(x + 11, dy), 1.8, Paint()..color = color);
    }
  }

  void _text(Canvas c, String s, Offset at, double size, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: s,
        style: TextStyle(
          fontSize: size,
          height: 1,
          color: color,
          fontFamilyFallback: const [
            'Segoe UI Symbol',
            'Apple Symbols',
            'Noto Music',
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(c, at);
  }

  @override
  bool shouldRepaint(StaffPainter old) =>
      old.pitch?.name != pitch?.name ||
      old.flags != flags ||
      old.hollow != hollow ||
      old.dotted != dotted ||
      old.color != color ||
      old.lineColor != lineColor;
}
