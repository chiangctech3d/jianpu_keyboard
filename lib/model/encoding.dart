import 'note.dart';

/// Texto da nota na sintaxe da fonte Jianpu ASCII
/// (github.com/RobertWinslow/jianpu-ascii-font):
///
/// acidente (`#`, `b`) + número + oitava (`'`, `''`, `,`, `,,`) +
/// linhas (`/`, `//`) + ponto (`.`) ou traço (` -`).
///
/// A ligadura ainda não entra no texto: na fonte ela fica numa linha à
/// parte, acima das notas.
String toJianpuAscii(Note note) {
  final digit = note.digit;
  if (digit == null) return '';
  final b = StringBuffer();
  switch (note.accidental) {
    case Accidental.sharp:
      b.write('#');
    case Accidental.flat:
      b.write('b');
    case Accidental.none:
  }
  b.write(digit);
  b.write((note.octave > 0 ? "'" : ',') * note.octave.abs());
  b.write('/' * note.underlines);
  switch (note.side) {
    case SideMark.dot:
      b.write('.');
    case SideMark.dash:
      b.write(' -');
    case SideMark.none:
  }
  return b.toString();
}
