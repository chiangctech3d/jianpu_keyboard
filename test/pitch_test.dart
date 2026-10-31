import 'package:flutter_test/flutter_test.dart';
import 'package:jianpu_keyboard/model/note.dart';
import 'package:jianpu_keyboard/model/pitch.dart';

MusicKey key(String label) => musicKeys.firstWhere((k) => k.label == label);

String name(Note note, String k) => pitchOf(note, key(k))!.name;

void main() {
  test('1 = C', () {
    expect(
      [for (var d = 1; d <= 7; d++) name(Note(digit: d), 'C')],
      ['C4', 'D4', 'E4', 'F4', 'G4', 'A4', 'B4'],
    );
  });

  test('1 = G: o 7 é F♯ uma oitava acima', () {
    expect(name(const Note(digit: 7), 'G'), 'F♯5');
  });

  test('1 = B♭: o 4 é E♭', () {
    expect(name(const Note(digit: 4), 'B♭'), 'E♭5');
  });

  test('pontos e acidentes', () {
    expect(name(const Note(digit: 1, octave: 1), 'C'), 'C5');
    expect(name(const Note(digit: 1, octave: -2), 'C'), 'C2');
    expect(
      name(const Note(digit: 4, accidental: Accidental.sharp), 'C'),
      'F♯4',
    );
    expect(
      name(const Note(digit: 7, accidental: Accidental.sharp), 'G'),
      'F𝄪5',
    );
    expect(pitchOf(const Note(digit: 3), key('C'))!.solfege, 'Mi');
  });

  test('pausa não tem altura', () {
    expect(pitchOf(const Note(digit: 0), key('C')), isNull);
  });

  test('duração', () {
    expect(beatsOf(const Note(digit: 1)), 1);
    expect(beatsOf(const Note(digit: 1, underlines: 1)), 0.5);
    expect(beatsOf(const Note(digit: 1, underlines: 2)), 0.25);
    expect(beatsOf(const Note(digit: 1, side: SideMark.dot)), 1.5);
    expect(beatsOf(const Note(digit: 1, side: SideMark.dash)), 2);
    expect(durationName(const Note(digit: 1, underlines: 1)), 'colcheia');
    expect(durationName(const Note(digit: 0)), 'pausa de semínima');
    expect(beatsLabel(0.5), '½ tempo');
    expect(beatsLabel(1.5), '1½ tempos');
  });
}
