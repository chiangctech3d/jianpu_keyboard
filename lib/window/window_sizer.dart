import 'dart:ui';

/// Muda o tamanho da área de conteúdo da janela do app, mantendo a borda
/// direita e o topo no lugar (o teclado numérico abre à esquerda).
abstract class WindowSizer {
  /// [size] em pixels lógicos.
  Future<void> setContentSize(Size size);
}
