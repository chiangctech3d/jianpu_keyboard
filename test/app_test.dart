import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jianpu_keyboard/ui/app.dart';

import 'fakes/fakes.dart';

void main() {
  late List<String?> clipboard;

  setUp(() {
    clipboard = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'Clipboard.setData') {
            clipboard.add((call.arguments as Map)['text'] as String?);
          }
          return null;
        });
  });

  Future<void> tap(WidgetTester tester, String key) async {
    await tester.tap(find.byKey(Key(key)));
    await tester.pumpAndSettle();
  }

  String digitText(WidgetTester tester) =>
      tester.widget<Text>(find.byKey(const Key('digit'))).data!;

  testWidgets('monta a nota, digita e limpa', (tester) async {
    final typer = FakeTyper();
    final sizer = FakeWindowSizer();
    await tester.pumpWidget(
      JianpuApp(typer: typer, isMac: false, windowSizer: sizer),
    );

    await tap(tester, 'keypad-toggle');
    expect(sizer.sizes.last, contentSize(keypadOpen: true));
    await tap(tester, 'pad-4');
    expect(digitText(tester), '4');
    await tap(tester, 'sharp');
    await tap(tester, 'upper-dot-1');
    await tap(tester, 'underline-2');
    expect(find.text("#4'//"), findsOneWidget);
    expect(find.text('F♯5  Fá♯'), findsOneWidget);

    await tap(tester, 'enter');
    expect(typer.typed, ["#4'//"]);
    expect(digitText(tester), '');
    expect(find.byKey(const Key('ascii')), findsNothing);

    await tap(tester, 'keypad-toggle');
    expect(sizer.sizes.last, contentSize(keypadOpen: false));
    expect(find.byKey(const Key('pad-4')), findsNothing);
  });

  testWidgets('enter desligado sem número', (tester) async {
    final typer = FakeTyper();
    await tester.pumpWidget(JianpuApp(typer: typer, isMac: false));
    await tap(tester, 'enter');
    expect(typer.typed, isEmpty);
  });

  testWidgets('tom muda o nome da nota', (tester) async {
    await tester.pumpWidget(JianpuApp(typer: FakeTyper(), isMac: false));
    await tap(tester, 'keypad-toggle');
    await tap(tester, 'pad-1');
    expect(find.text('C4  Dó'), findsOneWidget);
    await tap(tester, 'key-select');
    await tester.tap(find.text('G').last);
    await tester.pumpAndSettle();
    expect(find.text('G4  Sol'), findsOneWidget);
  });

  testWidgets('sem digitação copia e avisa (Mac oferece Permitir)', (
    tester,
  ) async {
    var opened = 0;
    await tester.pumpWidget(
      JianpuApp(
        typer: FakeTyper(result: false),
        isMac: true,
        onOpenSettings: () async => opened++,
      ),
    );
    await tap(tester, 'keypad-toggle');
    await tap(tester, 'pad-0');
    await tap(tester, 'enter');
    expect(clipboard, ['0']);
    expect(find.text('Copiado — cole com ⌘V'), findsOneWidget);
    await tester.tap(find.text('Permitir'));
    expect(opened, 1);
  });
}
