import 'dart:io';

import 'package:flutter/material.dart';

import 'native/macos_channel.dart';
import 'typing/macos_typer.dart';
import 'typing/typer.dart';
import 'typing/windows_typer.dart';
import 'ui/app.dart';
import 'window/macos_window_sizer.dart';
import 'window/window_sizer.dart';
import 'window/windows_window_sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Typer typer;
  final WindowSizer windowSizer;
  if (Platform.isMacOS) {
    typer = MacosTyper();
    windowSizer = MacosWindowSizer();
    requestAccessibility();
  } else {
    typer = WindowsTyper();
    windowSizer = WindowsWindowSizer();
  }

  await windowSizer.setContentSize(contentSize(keypadOpen: false));

  runApp(
    JianpuApp(
      typer: typer,
      isMac: Platform.isMacOS,
      onOpenSettings: Platform.isMacOS ? openAccessibilitySettings : null,
      windowSizer: windowSizer,
    ),
  );
}
