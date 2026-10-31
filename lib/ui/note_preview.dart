import 'package:flutter/material.dart';

import '../model/encoding.dart';
import '../model/note.dart';
import '../model/pitch.dart';
import 'controls.dart';
import 'louvor.dart';

/// Tamanho do painel de baixo em 100%.
const Size previewSize = Size(340, 128);

/// Painel de baixo: o tom, a nota na pauta e o que ela é.
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
    final c = Louvor.of(context);
    final pitch = pitchOf(note, musicKey);
    final rest = note.digit == 0;
    final text = toJianpuAscii(note);

    return Container(
      width: previewSize.width,
      height: previewSize.height,
      decoration: BoxDecoration(
        color: c.folha,
        border: Border(top: BorderSide(color: c.linha)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Tom: o que vale o "1" (`.rot` + `select.sel`).
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tom', style: ui(t12, c.tinta2, forte: true)),
              const SizedBox(height: 6),
              _KeySelect(musicKey: musicKey, onChanged: onKeyChanged),
            ],
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 84,
            height: 96,
            child: CustomPaint(
              painter: StaffPainter(
                pitch: note.isEmpty || rest ? null : pitch,
                flags: note.underlines,
                hollow: note.side == SideMark.dash && note.underlines == 0,
                dotted: note.side == SideMark.dot,
                color: c.tinta,
                lineColor: c.linhaForte,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            // Encolhe o texto em vez de quebrar a linha.
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: note.isEmpty
                  ? Text('Escolha um\nnúmero.', style: ui(t14, c.tinta3))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rest ? 'Pausa' : pitch!.name,
                          key: const Key('pitch-name'),
                          style: ui(t16, c.tinta, forte: true),
                        ),
                        if (!rest)
                          Text(
                            pitch!.solfege,
                            key: const Key('pitch-solfege'),
                            style: ui(t14, c.tinta2),
                          ),
                        Text(
                          durationName(note) ?? 'Duração livre',
                          style: ui(t12, c.tinta3),
                        ),
                        Text(
                          beatsLabel(beatsOf(note)),
                          style: ui(t12, c.tinta3),
                        ),
                        const SizedBox(height: 4),
                        // `.tag-tipo`: o texto que vai para o documento.
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: c.papel2,
                            borderRadius: BorderRadius.circular(rPadrao),
                          ),
                          child: Text(
                            text,
                            key: const Key('ascii'),
                            style: mono(t14, c.tinta2),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// `select.sel`: folha com linha forte; o menu mostra o tom por extenso.
class _KeySelect extends StatelessWidget {
  const _KeySelect({required this.musicKey, required this.onChanged});

  final MusicKey musicKey;
  final ValueChanged<MusicKey> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = Louvor.of(context);
    return Container(
      height: 34,
      padding: const EdgeInsets.only(left: 10, right: 4),
      decoration: BoxDecoration(
        color: c.folha,
        borderRadius: BorderRadius.circular(rPadrao),
        border: Border.all(color: c.linhaForte),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<MusicKey>(
          key: const Key('key-select'),
          value: musicKey,
          focusColor: Colors.transparent,
          dropdownColor: c.folha,
          borderRadius: BorderRadius.circular(rMedio),
          icon: Padding(
            padding: const EdgeInsets.only(left: 6),
            child: LvIcon(Icone.abaixo, color: c.tinta2, size: 16),
          ),
          style: ui(t14, c.tinta),
          menuMaxHeight: 320,
          selectedItemBuilder: (_) => [
            for (final k in musicKeys)
              Align(
                alignment: Alignment.centerLeft,
                child: Text('1 = ${k.label}', style: ui(t14, c.tinta)),
              ),
          ],
          items: [
            for (final k in musicKeys)
              DropdownMenuItem(
                value: k,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: k.label,
                        style: ui(t14, c.tinta, forte: true),
                      ),
                      TextSpan(
                        text: '  ${k.longName}',
                        style: ui(t14, c.tinta2),
                      ),
                    ],
                  ),
                ),
              ),
          ],
          onChanged: (k) {
            if (k != null) onChanged(k);
          },
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
      text: TextSpan(text: s, style: musica(size, color)),
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
