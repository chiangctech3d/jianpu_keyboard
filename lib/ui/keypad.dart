import 'package:flutter/material.dart';

/// Largura do teclado numérico em 100%.
const double keypadWidth = 156;

/// Teclado numérico que abre à esquerda: 1–7, 0 (pausa) e apagar.
class Keypad extends StatelessWidget {
  const Keypad({super.key, required this.onDigit, required this.onClear});

  final ValueChanged<int> onDigit;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget key(Widget label, VoidCallback onTap, {Key? key, String? tip}) =>
        Padding(
          padding: const EdgeInsets.all(3),
          child: Tooltip(
            message: tip ?? '',
            waitDuration: const Duration(milliseconds: 600),
            child: SizedBox(
              width: 44,
              height: 52,
              child: OutlinedButton(
                key: key,
                onPressed: onTap,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(color: scheme.outlineVariant),
                ),
                child: label,
              ),
            ),
          ),
        );

    Widget digit(int d) => key(
      Text('$d', style: const TextStyle(fontSize: 24, height: 1)),
      () => onDigit(d),
      key: Key('pad-$d'),
      tip: d == 0 ? 'Pausa' : null,
    );

    return Container(
      width: keypadWidth,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final d in [1, 2, 3]) digit(d),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final d in [4, 5, 6]) digit(d),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                digit(7),
                digit(0),
                key(
                  const Icon(Icons.backspace_outlined, size: 22),
                  onClear,
                  key: const Key('pad-clear'),
                  tip: 'Limpar',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
