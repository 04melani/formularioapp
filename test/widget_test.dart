import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formulario_moderno/main.dart'; // Asegúrate de que la ruta del archivo sea correcta

void main() {
  testWidgets('Formulario de Registro test', (WidgetTester tester) async {
    // Construye la aplicación y dispara un fotograma.
    await tester.pumpWidget(MyApp());

    // Verifica que el título del formulario está presente.
    expect(find.text('Registro de Usuario'), findsOneWidget);

    // Verifica que los campos del formulario están presentes.
    expect(find.byType(TextFormField), findsNWidgets(5)); // Cédula, Nombres, Apellidos, Fecha de nacimiento, Edad
    expect(find.byType(DropdownButtonFormField), findsNWidgets(2)); // Género, Estado Civil
    expect(find.byType(ElevatedButton), findsNWidgets(2)); // Botones Siguiente y Salir

    // Encuentra el campo de texto de cédula y escribe un valor.
    await tester.enterText(find.byIcon(Icons.credit_card), '1234567890');
    await tester.enterText(find.byIcon(Icons.person), 'Juan');
    await tester.enterText(find.byIcon(Icons.person_outline), 'Pérez');

    // Simula el tap para seleccionar la fecha de nacimiento.
    await tester.tap(find.byIcon(Icons.calendar_today));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Verifica que los valores escritos están presentes.
    expect(find.text('1234567890'), findsOneWidget);
    expect(find.text('Juan'), findsOneWidget);
    expect(find.text('Pérez'), findsOneWidget);

    // Simula la selección del género.
    await tester.tap(find.byType(DropdownButtonFormField).at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Femenino').last);
    await tester.pumpAndSettle();
    expect(find.text('Femenino'), findsOneWidget);

    // Simula la selección del estado civil.
    await tester.tap(find.byType(DropdownButtonFormField).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Casado').last);
    await tester.pumpAndSettle();
    expect(find.text('Casado'), findsOneWidget);

    // Simula el botón 'Siguiente'.
    await tester.tap(find.text('Siguiente'));
    await tester.pump();

    // Verifica que la validación se está realizando.
    expect(find.text('Por favor, ingrese su cédula'), findsNothing);
    expect(find.text('Por favor, ingrese sus nombres'), findsNothing);
    expect(find.text('Por favor, ingrese sus apellidos'), findsNothing);
    expect(find.text('Por favor, ingrese su fecha de nacimiento'), findsNothing);
  });
}
