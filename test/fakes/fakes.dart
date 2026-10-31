import 'dart:ui';

import 'package:jianpu_keyboard/typing/typer.dart';
import 'package:jianpu_keyboard/window/window_sizer.dart';

class FakeTyper implements Typer {
  FakeTyper({this.result = true});

  final bool result;
  final List<String> typed = [];

  @override
  Future<bool> type(String text) async {
    typed.add(text);
    return result;
  }
}

class FakeWindowSizer implements WindowSizer {
  final List<Size> sizes = [];

  @override
  Future<void> setContentSize(Size size) async => sizes.add(size);
}
