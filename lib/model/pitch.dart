import 'note.dart';

/// Tom da música: o que o "1" vale (1 = C, 1 = G…).
class MusicKey {
  const MusicKey(this.label, this.letter, this.semitone);

  /// Nome mostrado na caixa de seleção.
  final String label;

  /// Letra da tônica: 0 = C … 6 = B.
  final int letter;

  /// Semitons acima de C.
  final int semitone;

  /// Tom por extenso, ex.: `Ré bemol maior`.
  String get longName =>
      '${Pitch(letter, 4, semitone - _majorScale[letter]).solfege} maior';
}

const musicKeys = [
  MusicKey('C', 0, 0),
  MusicKey('D♭', 1, 1),
  MusicKey('D', 1, 2),
  MusicKey('E♭', 2, 3),
  MusicKey('E', 2, 4),
  MusicKey('F', 3, 5),
  MusicKey('F♯', 3, 6),
  MusicKey('G', 4, 7),
  MusicKey('A♭', 5, 8),
  MusicKey('A', 5, 9),
  MusicKey('B♭', 6, 10),
  MusicKey('B', 6, 11),
];

const _majorScale = [0, 2, 4, 5, 7, 9, 11];
const _letterNames = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
const _solfege = ['Dó', 'Ré', 'Mi', 'Fá', 'Sol', 'Lá', 'Si'];
const _accidentalWords = {
  -2: 'dobrado bemol',
  -1: 'bemol',
  1: 'sustenido',
  2: 'dobrado sustenido',
};
const _accidentalSigns = {-2: '𝄫', -1: '♭', 0: '', 1: '♯', 2: '𝄪'};

/// Altura de uma nota escrita, já com a grafia certa para o tom.
class Pitch {
  const Pitch(this.letter, this.octave, this.alter);

  /// 0 = C … 6 = B.
  final int letter;

  /// Oitava científica (C4 = dó central).
  final int octave;

  /// Acidente em semitons: −2 a 2.
  final int alter;

  /// Posição diatônica (degraus de pauta) contada a partir de C0.
  int get step => letter + 7 * octave;

  String get accidentalSign => _accidentalSigns[alter] ?? '';

  /// Ex.: `F♯4`.
  String get name => '${_letterNames[letter]}$accidentalSign$octave';

  /// Por extenso, ex.: `Fá sustenido`.
  String get solfege => [_solfege[letter], ?_accidentalWords[alter]].join(' ');
}

/// Altura da nota no tom [key]; `null` para pausa ou nota vazia.
/// O "1" sem pontos fica na oitava 4.
Pitch? pitchOf(Note note, MusicKey key) {
  final digit = note.digit;
  if (digit == null || digit < 1 || digit > 7) return null;
  final d = digit - 1;
  final letterIndex = key.letter + d;
  final letter = letterIndex % 7;
  final octave = 4 + letterIndex ~/ 7 + note.octave;
  final alterSemis = switch (note.accidental) {
    Accidental.sharp => 1,
    Accidental.flat => -1,
    Accidental.none => 0,
  };
  // Semitons reais menos os da letra natural, na mesma oitava.
  final actual = key.semitone + _majorScale[d] + alterSemis;
  final natural = _majorScale[letter] + 12 * (letterIndex ~/ 7);
  return Pitch(letter, octave, actual - natural);
}

/// Duração em tempos (semínima = 1).
double beatsOf(Note note) {
  final base = switch (note.underlines) {
    1 => 0.5,
    2 => 0.25,
    _ => 1.0,
  };
  return switch (note.side) {
    SideMark.dot => base * 1.5,
    SideMark.dash => base + 1,
    SideMark.none => base,
  };
}

/// Nome da figura em português; `null` quando não há figura simples.
String? durationName(Note note) {
  final rest = note.digit == 0;
  return switch (beatsOf(note)) {
    0.25 => rest ? 'pausa de semicolcheia' : 'semicolcheia',
    0.5 => rest ? 'pausa de colcheia' : 'colcheia',
    1.0 => rest ? 'pausa de semínima' : 'semínima',
    1.5 => rest ? 'pausa de semínima pontuada' : 'semínima pontuada',
    2.0 => rest ? 'pausa de mínima' : 'mínima',
    _ => null,
  };
}

/// Ex.: `1 tempo`, `½ tempo`, `1½ tempo`.
String beatsLabel(double beats) {
  final whole = beats.floor();
  final frac = switch (beats - whole) {
    0.25 => '¼',
    0.5 => '½',
    0.75 => '¾',
    _ => '',
  };
  final n = whole == 0 && frac.isNotEmpty ? frac : '$whole$frac';
  return '$n ${beats > 1 ? 'tempos' : 'tempo'}';
}
