import 'package:flutter_test/flutter_test.dart';
import 'package:jianpu_keyboard/model/note.dart';

void main() {
  const n = Note(digit: 5);

  group('pontos de cima', () {
    test('o de perto acende um; o de fora acende os dois', () {
      expect(n.tapUpperDot(1).octave, 1);
      expect(n.tapUpperDot(2).octave, 2);
    });
    test('com os dois acesos, o de perto deixa só ele', () {
      expect(n.tapUpperDot(2).tapUpperDot(1).octave, 1);
    });
    test('clicar no que está aceso apaga', () {
      expect(n.tapUpperDot(1).tapUpperDot(1).octave, 0);
      expect(n.tapUpperDot(2).tapUpperDot(2).octave, 0);
    });
    test('acender em cima apaga embaixo e vice-versa', () {
      expect(n.tapLowerDot(2).tapUpperDot(1).octave, 1);
      expect(n.tapUpperDot(2).tapLowerDot(1).octave, -1);
    });
  });

  test('pontos de baixo espelhados', () {
    expect(n.tapLowerDot(1).octave, -1);
    expect(n.tapLowerDot(2).octave, -2);
    expect(n.tapLowerDot(2).tapLowerDot(1).octave, -1);
    expect(n.tapLowerDot(2).tapLowerDot(2).octave, 0);
  });

  test('linhas de baixo', () {
    expect(n.tapUnderline(1).underlines, 1);
    expect(n.tapUnderline(2).underlines, 2);
    expect(n.tapUnderline(2).tapUnderline(1).underlines, 1);
    expect(n.tapUnderline(1).tapUnderline(1).underlines, 0);
  });

  group('ponto e traço laterais', () {
    test('ponto apaga as linhas', () {
      final dotted = n.tapUnderline(2).tapDot();
      expect(dotted.side, SideMark.dot);
      expect(dotted.underlines, 0);
    });
    test('um troca pelo outro', () {
      expect(n.tapDot().tapDash().side, SideMark.dash);
      expect(n.tapDash().tapDot().side, SideMark.dot);
    });
    test('clicar de novo apaga', () {
      expect(n.tapDot().tapDot().side, SideMark.none);
      expect(n.tapDash().tapDash().side, SideMark.none);
    });
  });

  test('sustenido e bemol', () {
    expect(n.tapSharp().accidental, Accidental.sharp);
    expect(n.tapSharp().tapFlat().accidental, Accidental.flat);
    expect(n.tapFlat().tapFlat().accidental, Accidental.none);
  });

  test('ligadura liga e desliga', () {
    expect(n.tapTie().tie, isTrue);
    expect(n.tapTie().tapTie().tie, isFalse);
  });
}
