import 'dart:ffi' hide Size;
import 'dart:ui';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import 'window_sizer.dart';

/// Redimensiona a janela do runner (classe criada em win32_window.cpp)
/// mantendo a borda direita, o topo e a moldura.
class WindowsWindowSizer implements WindowSizer {
  @override
  Future<void> setContentSize(Size size) async {
    using((arena) {
      final hwnd = FindWindow(
        arena.pcwstr('FLUTTER_RUNNER_WIN32_WINDOW'),
        null,
      ).value;
      if (hwnd.isNull) return;
      final scale = GetDpiForWindow(hwnd) / 96;
      final window = arena<RECT>();
      final client = arena<RECT>();
      GetWindowRect(hwnd, window);
      GetClientRect(hwnd, client);
      final frameW = (window.ref.right - window.ref.left) - client.ref.right;
      final frameH = (window.ref.bottom - window.ref.top) - client.ref.bottom;
      final width = (size.width * scale).round() + frameW;
      SetWindowPos(
        hwnd,
        null,
        window.ref.right - width,
        window.ref.top,
        width,
        (size.height * scale).round() + frameH,
        SET_WINDOW_POS_FLAGS(SWP_NOZORDER | SWP_NOACTIVATE),
      );
    });
  }
}
