import 'package:flutter/material.dart';

import 'controls.dart';
import 'louvor.dart';

/// Largura do teclado numérico em 100%.
const double keypadWidth = 168;

/// Teclado numérico que abre à esquerda: 1–7, 0 (pausa) e limpar.
/// O número escolhido fica pressionado (invertido para tinta).
class Keypad extends StatelessWidget {
  const Keypad({
    super.key,
    required this.digit,
    required this.onDigit,
    required this.onClear,
  });

  final int? digit;
  final ValueChanged<int> onDigit;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final c = Louvor.of(context);

    Widget key(int d) => Padding(
      padding: const EdgeInsets.all(3),
      child: LvButton(
        key: Key('pad-$d'),
        tooltip: d == 0 ? 'Pausa' : null,
        pressionado: digit == d,
        width: 42,
        height: 44,
        onPressed: () => onDigit(d),
        child: (fg) => Text('$d', style: mono(t20, fg, peso: 500)),
      ),
    );

    return Container(
      width: keypadWidth,
      decoration: BoxDecoration(
        color: c.folha,
        border: Border(right: BorderSide(color: c.linha)),
      ),
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 34,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Número', style: ui(t12, c.tinta2, forte: true)),
            ),
          ),
          const Spacer(),
          for (final row in const [
            [1, 2, 3],
            [4, 5, 6],
          ])
            Row(children: [for (final d in row) key(d)]),
          Row(
            children: [
              key(7),
              key(0),
              Padding(
                padding: const EdgeInsets.all(3),
                child: LvButton(
                  key: const Key('pad-clear'),
                  tooltip: 'Limpar a nota',
                  width: 42,
                  height: 44,
                  onPressed: onClear,
                  child: (fg) => LvIcon(Icone.apagar, color: fg),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text('0 é pausa.', style: ui(t12, c.tinta3)),
        ],
      ),
    );
  }
}
