/// Acidente à esquerda do número.
enum Accidental { none, sharp, flat }

/// Marca à direita do número: ponto de aumento ou traço de extensão.
enum SideMark { none, dot, dash }

/// Uma nota de jianpu sendo montada no editor.
///
/// [octave]: pontos acima (1, 2) ou abaixo (−1, −2) do número.
/// [underlines]: linhas abaixo do número (1 = colcheia, 2 = semicolcheia).
class Note {
  const Note({
    this.digit,
    this.octave = 0,
    this.underlines = 0,
    this.side = SideMark.none,
    this.accidental = Accidental.none,
    this.tie = false,
  });

  /// 0 (pausa) a 7; `null` enquanto nada foi digitado.
  final int? digit;
  final int octave;
  final int underlines;
  final SideMark side;
  final Accidental accidental;
  final bool tie;

  bool get isEmpty => digit == null;

  Note copyWith({
    int? Function()? digit,
    int? octave,
    int? underlines,
    SideMark? side,
    Accidental? accidental,
    bool? tie,
  }) => Note(
    digit: digit != null ? digit() : this.digit,
    octave: octave ?? this.octave,
    underlines: underlines ?? this.underlines,
    side: side ?? this.side,
    accidental: accidental ?? this.accidental,
    tie: tie ?? this.tie,
  );

  Note withDigit(int d) => copyWith(digit: () => d);

  /// Pontos de cima: [level] 1 é o mais perto do número, 2 o de fora.
  /// Clicar no de fora acende os dois; clicar no que já define o estado
  /// apaga tudo. Acender em cima apaga os de baixo.
  Note tapUpperDot(int level) => copyWith(octave: octave == level ? 0 : level);

  /// Pontos de baixo: as mesmas regras, espelhadas.
  Note tapLowerDot(int level) =>
      copyWith(octave: octave == -level ? 0 : -level);

  /// Linhas de baixo: [level] 1 é a de cima (uma linha), 2 acende as duas.
  Note tapUnderline(int level) =>
      copyWith(underlines: underlines == level ? 0 : level);

  /// O ponto lateral apaga o traço e as linhas de baixo.
  Note tapDot() => side == SideMark.dot
      ? copyWith(side: SideMark.none)
      : copyWith(side: SideMark.dot, underlines: 0);

  /// O traço lateral apaga o ponto.
  Note tapDash() =>
      copyWith(side: side == SideMark.dash ? SideMark.none : SideMark.dash);

  Note tapSharp() => copyWith(
    accidental: accidental == Accidental.sharp
        ? Accidental.none
        : Accidental.sharp,
  );

  Note tapFlat() => copyWith(
    accidental: accidental == Accidental.flat
        ? Accidental.none
        : Accidental.flat,
  );

  Note tapTie() => copyWith(tie: !tie);

  @override
  bool operator ==(Object other) =>
      other is Note &&
      other.digit == digit &&
      other.octave == octave &&
      other.underlines == underlines &&
      other.side == side &&
      other.accidental == accidental &&
      other.tie == tie;

  @override
  int get hashCode =>
      Object.hash(digit, octave, underlines, side, accidental, tie);
}
