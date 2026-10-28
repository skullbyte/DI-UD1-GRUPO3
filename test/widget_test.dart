import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rpg_creator/data/game_data.dart';
import 'package:rpg_creator/main.dart';
import 'package:rpg_creator/models/character_data.dart';
import 'package:rpg_creator/screens/screen1_identity.dart';
import 'package:rpg_creator/screens/screen3_equipment.dart';

/// Pantalla de móvil (390 x 844 lógicos).
void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

/// Hace scroll hasta el widget y lo deja arriba (para que la barra inferior no lo tape).
Future<void> _show(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(finder, 200, scrollable: find.byType(Scrollable).first);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}

void main() {
  // rootBundle guarda en caché el archivo leído; se limpia para que cada test lo lea de nuevo.
  tearDown(rootBundle.clear);

  group('game_data.json', () {
    testWidgets('se carga con jsonDecode y tiene razas, clases y objetos', (tester) async {
      expect((await loadSection('razas')).length, 4);
      expect((await loadSection('clases')).length, 4);
      final objetos = await loadSection('objetos');
      expect(objetos.length, 6);
      for (final o in objetos) {
        expect(o, containsPair('bono', isA<String>()));
        expect(o['imagen'], startsWith('assets/images/'));
      }
    });
  });

  group('Reglas del personaje', () {
    test('puntos disponibles parten de 15 y bajan al subir atributos', () {
      final c = CharacterData();
      expect(c.pointsAvailable(c.physical), 15);
      expect(c.pointsAvailable(c.mental), 15);
      c.setAttribute(c.physical, 'Fuerza', 16);
      c.setAttribute(c.mental, 'Sabiduría', 14);
      expect(c.pointsAvailable(c.physical), 9);
      expect(c.pointsAvailable(c.mental), 11);
    });

    test('setAttribute respeta mínimo, máximo y puntos libres', () {
      final c = CharacterData();
      c.setAttribute(c.physical, 'Fuerza', 30);
      expect(c.physical['Fuerza'], 18);
      c.setAttribute(c.physical, 'Fuerza', 0);
      expect(c.physical['Fuerza'], 8);
      c.setAttribute(c.physical, 'Fuerza', 18); // gasta 8
      c.setAttribute(c.physical, 'Agilidad', 18); // solo quedan 7 puntos: llega a 17
      expect(c.physical['Agilidad'], 17);
      expect(c.pointsAvailable(c.physical), 0);
    });

    test('el equipamiento suma +2 al atributo de su bono', () {
      final c = CharacterData();
      c.mental['Inteligencia'] = 13;
      c.equipment = {'nombre': 'Bastón Arcano', 'bono': 'Inteligencia'};
      expect(c.finalValue('Inteligencia'), 15);
      expect(c.finalValue('Fuerza'), 10);
    });
  });

  testWidgets('Recorrido completo: identidad → clase → equipo → ficha final', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const RPGCreatorApp());
    await tester.pumpAndSettle();

    // ── Pantalla 1 ──
    expect(find.text('Identidad y Raza'), findsOneWidget);
    await tester.tap(find.text('IR AL VESTIDOR'));
    await tester.pump();
    expect(find.textContaining('Escribe un nombre'), findsOneWidget, reason: 'no deja avanzar sin datos');
    await tester.pumpAndSettle(const Duration(seconds: 5));

    await tester.enterText(find.byType(TextField).at(0), 'Aldric Tramoya');
    await tester.enterText(find.byType(TextField).at(1), 'Criado entre bambalinas.');
    await _show(tester, find.text('Elfo'));
    await tester.tap(find.text('Elfo'));
    await tester.pumpAndSettle();
    await _show(tester, find.text('Has elegido: Elfo'));
    expect(find.text('Has elegido: Elfo'), findsOneWidget);
    await tester.tap(find.text('IR AL VESTIDOR'));
    await tester.pumpAndSettle();

    // ── Pantalla 2 ──
    expect(find.text('Clase y Atributos'), findsOneWidget);
    await tester.tap(find.text('Guerrero'));
    await tester.pumpAndSettle();
    await _show(tester, find.textContaining('Te quedan'));
    final plus = find.byIcon(Icons.add);
    for (int i = 0; i < 6; i++) {
      await tester.tap(plus.at(0)); // Fuerza 10 -> 16
    }
    for (int i = 0; i < 20; i++) {
      await tester.tap(plus.at(1), warnIfMissed: false); // Agilidad: se para en el máximo (18)
    }
    await tester.pumpAndSettle();
    expect(find.text('1 / 15 puntos'), findsOneWidget);
    for (int i = 0; i < 5; i++) {
      await tester.tap(plus.at(2), warnIfMissed: false); // Constitución: solo queda 1 punto
    }
    await tester.pumpAndSettle();
    expect(find.text('0 / 15 puntos'), findsOneWidget);
    expect(find.text('16'), findsOneWidget);
    expect(find.text('18'), findsOneWidget);
    expect(find.text('11'), findsOneWidget);
    expect(find.text('19'), findsNothing, reason: 'nunca supera el máximo');
    await tester.tap(find.text('A LA CABINA DE LUCES'));
    await tester.pumpAndSettle();

    // ── Pantalla 3 ──
    expect(find.text('Equipo y Mente'), findsOneWidget);
    // Filtrar por "Accesorio" con el Dropdown
    await tester.tap(find.text('Todos los objetos'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Accesorio').last);
    await tester.pumpAndSettle();
    expect(find.text('Espada Larga'), findsNothing);
    expect(find.text('Capa Élfica'), findsOneWidget);
    await tester.tap(find.text('Amuleto de Sabiduría'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Susurra consejos'), findsOneWidget, reason: 'detalle del objeto visible');
    // El Switch apaga el detalle
    await _show(tester, find.byType(Switch));
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(find.textContaining('Susurra consejos'), findsNothing);
    // Slider de Sabiduría al máximo
    await _show(tester, find.byType(Slider).at(1));
    await tester.drag(find.byType(Slider).at(1), const Offset(400, 0));
    await tester.pumpAndSettle();
    expect(find.text('7 / 15 puntos'), findsOneWidget); // 18 - 10 = 8 usados
    await tester.tap(find.text('¡A ESCENA!'));
    await tester.pumpAndSettle();

    // ── Pantalla 4 ──
    expect(find.text('Aldric Tramoya'), findsOneWidget);
    expect(find.text('Elfo · Guerrero'), findsOneWidget);
    expect(find.text('Amuleto de Sabiduría'), findsOneWidget);
    expect(find.text('20'), findsWidgets, reason: 'Sabiduría 18 + 2 del amuleto');
    expect(find.byType(Checkbox), findsOneWidget);

    // Modificar la clase desde la ficha
    await tester.tap(find.byTooltip('Modificar').at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mago'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('GUARDAR CAMBIOS'));
    await tester.pumpAndSettle();
    expect(find.text('Elfo · Mago'), findsOneWidget);

    // Volver al proceso conserva los datos
    await tester.tap(find.text('MODIFICAR'));
    await tester.pumpAndSettle();
    expect(find.byType(Screen3Equipment), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.byType(Screen1Identity), findsOneWidget);
    final nameField = tester.widget<TextField>(find.byType(TextField, skipOffstage: false).first);
    expect(nameField.controller!.text, 'Aldric Tramoya', reason: 'el TextField conserva el nombre');
  });

  testWidgets('No pasa de la pantalla 2 sin clase ni de la 3 sin objeto', (tester) async {
    _phone(tester);
    await tester.pumpWidget(const RPGCreatorApp());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Test');
    await _show(tester, find.text('Orco'));
    await tester.tap(find.text('Orco'));
    await tester.tap(find.text('IR AL VESTIDOR'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('A LA CABINA DE LUCES'));
    await tester.pump();
    expect(find.textContaining('Elige una clase'), findsOneWidget);
  });
}
