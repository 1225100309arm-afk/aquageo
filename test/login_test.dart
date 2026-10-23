import 'package:aquageo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('login con la cuenta demo abre el inicio', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const AquaGeoApp());
    expect(find.text('Bienvenido'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), '10432');
    await tester.enterText(find.byType(TextFormField).at(1), 'agua123');
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Familia Sánchez'), findsOneWidget);
    expect(find.text('Pagar ahora'), findsOneWidget);
  });

  testWidgets('contraseña incorrecta muestra aviso y no entra', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const AquaGeoApp());
    await tester.enterText(find.byType(TextFormField).at(0), '10432');
    await tester.enterText(find.byType(TextFormField).at(1), 'incorrecta');
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('Número de contrato o contraseña incorrectos.'), findsOneWidget);
    expect(find.text('Bienvenido'), findsOneWidget);
  });
}
