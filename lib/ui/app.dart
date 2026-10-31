import 'package:flutter/material.dart';

import '../model/encoding.dart';
import '../model/note.dart';
import '../model/pitch.dart';
import '../typing/clipboard_fallback.dart';
import '../typing/typer.dart';
import '../window/window_sizer.dart';
import 'keypad.dart';
import 'louvor.dart';
import 'note_editor.dart';
import 'note_preview.dart';

/// Tamanho da janela em 100%, sem e com o teclado numérico.
Size contentSize({required bool keypadOpen}) => Size(
  editorSize.width + (keypadOpen ? keypadWidth : 0),
  editorSize.height + previewSize.height,
);

class JianpuApp extends StatelessWidget {
  const JianpuApp({
    super.key,
    required this.typer,
    required this.isMac,
    this.onOpenSettings,
    this.windowSizer,
  });

  final Typer typer;
  final bool isMac;

  /// Abre os Ajustes de Acessibilidade (só no Mac).
  final Future<void> Function()? onOpenSettings;

  /// Alarga a janela para a esquerda quando o teclado numérico abre.
  final WindowSizer? windowSizer;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teclado Jianpu',
      debugShowCheckedModeBanner: false,
      theme: louvorTheme(Brightness.light),
      darkTheme: louvorTheme(Brightness.dark),
      home: _Home(
        typer: typer,
        isMac: isMac,
        onOpenSettings: onOpenSettings,
        windowSizer: windowSizer,
      ),
    );
  }
}

class _Home extends StatefulWidget {
  const _Home({
    required this.typer,
    required this.isMac,
    required this.onOpenSettings,
    required this.windowSizer,
  });

  final Typer typer;
  final bool isMac;
  final Future<void> Function()? onOpenSettings;
  final WindowSizer? windowSizer;

  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  Note _note = const Note();
  MusicKey _key = musicKeys.first;
  bool _keypadOpen = false;

  void _toggleKeypad() {
    setState(() => _keypadOpen = !_keypadOpen);
    widget.windowSizer?.setContentSize(contentSize(keypadOpen: _keypadOpen));
  }

  Future<void> _enter() async {
    final text = toJianpuAscii(_note);
    if (text.isEmpty) return;
    setState(() => _note = const Note());
    if (!await widget.typer.type(text)) await _fallback(text);
  }

  Future<void> _fallback(String text) async {
    final messenger = ScaffoldMessenger.of(context);
    await copyFallback(text);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Copiado — cole com ${widget.isMac ? '⌘V' : 'Ctrl+V'}'),
          duration: const Duration(seconds: 3),
          action: widget.isMac && widget.onOpenSettings != null
              ? SnackBarAction(
                  label: 'Permitir',
                  onPressed: widget.onOpenSettings!,
                )
              : null,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Desenhado em 100% e escalado para caber na janela.
      body: SizedBox.expand(
        child: FittedBox(
          child: SizedBox.fromSize(
            size: contentSize(keypadOpen: _keypadOpen),
            child: Row(
              children: [
                if (_keypadOpen)
                  Keypad(
                    digit: _note.digit,
                    onDigit: (d) => setState(() => _note = _note.withDigit(d)),
                    onClear: () => setState(() => _note = const Note()),
                  ),
                Column(
                  children: [
                    NoteEditor(
                      note: _note,
                      onChanged: (n) => setState(() => _note = n),
                      onEnter: _enter,
                      keypadOpen: _keypadOpen,
                      onToggleKeypad: _toggleKeypad,
                    ),
                    NotePreview(
                      note: _note,
                      musicKey: _key,
                      onKeyChanged: (k) => setState(() => _key = k),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
