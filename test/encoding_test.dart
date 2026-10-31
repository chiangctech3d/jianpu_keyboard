import 'package:flutter_test/flutter_test.dart';
import 'package:jianpu_keyboard/model/encoding.dart';
import 'package:jianpu_keyboard/model/note.dart';

void main() {
  test('vazia não gera texto', () {
    expect(toJianpuAscii(const Note()), '');
  });

  test('número simples e pausa', () {
    expect(toJianpuAscii(const Note(digit: 3)), '3');
    expect(toJianpuAscii(const Note(digit: 0)), '0');
  });

  test('oitavas', () {
    expect(toJianpuAscii(const Note(digit: 1, octave: 1)), "1'");
    expect(toJianpuAscii(const Note(digit: 1, octave: 2)), "1''");
    expect(toJianpuAscii(const Note(digit: 1, octave: -1)), '1,');
    expect(toJianpuAscii(const Note(digit: 1, octave: -2)), '1,,');
  });

  test('linhas, ponto e traço', () {
    expect(toJianpuAscii(const Note(digit: 2, underlines: 1)), '2/');
    expect(toJianpuAscii(const Note(digit: 2, underlines: 2)), '2//');
    expect(toJianpuAscii(const Note(digit: 5, side: SideMark.dot)), '5.');
    expect(toJianpuAscii(const Note(digit: 5, side: SideMark.dash)), '5 -');
  });

  test('ordem: acidente, número, oitava, linhas, ponto', () {
    expect(
      toJianpuAscii(
        const Note(
          digit: 4,
          accidental: Accidental.sharp,
          octave: 1,
          underlines: 2,
        ),
      ),
      "#4'//",
    );
    expect(
      toJianpuAscii(
        const Note(
          digit: 7,
          accidental: Accidental.flat,
          octave: -1,
          side: SideMark.dot,
        ),
      ),
      'b7,.',
    );
  });
}
