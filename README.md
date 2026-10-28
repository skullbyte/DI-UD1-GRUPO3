# Creador de personaje RPG

Proyecto Flutter de Desarrollo de Interfaces. La app crea un personaje en 4 pantallas
ambientadas en un teatro: cada pantalla es una zona distinta del escenario.

| Pantalla | Escenario | Contenido |
|---|---|---|
| 1. Identidad y raza | Backstage | Nombre, biografía y raza |
| 2. Clase y atributos físicos | Vestidor | Clase y Fuerza / Agilidad / Constitución (rombos rojos) |
| 3. Equipamiento y atributos mentales | Cabina de luces | Objeto e Inteligencia / Sabiduría / Carisma (círculos azules) |
| 4. Ficha final | Teatro visto desde el público | Resumen, hexágono de parámetros y opciones para modificar |

## Diseño
- Figma: https://www.figma.com/design/B2sijKBXd0g5sFxYwGuXx1/Pagina-2
- Capturas del diseño de Figma: `docs/figma/`
- Capturas de la app ya implementada: `docs/capturas_app/`

## Estructura
```
lib/
├── main.dart                     MaterialApp, tema y pantalla inicial
├── data/game_data.dart           Lectura de game_data.json con rootBundle + jsonDecode
├── models/character_data.dart    Datos del personaje y reglas de puntos
├── theme/app_theme.dart          Colores y tipografías del Figma (Cinzel, Crimson Text)
├── screens/
│   ├── screen1_identity.dart
│   ├── screen2_class.dart
│   ├── screen3_equipment.dart
│   └── screen4_summary.dart
└── widgets/
    ├── common.dart               Scaffold de escena, botones, cabecera, filas de opción
    ├── attributes.dart           AttributeBadge: rombo (físico) o esfera (mental)
    └── hexagon_chart.dart        Hexágono de parámetros estilo JoJo
assets/
├── game_data.json                razas, clases y objetos
├── images/                       retratos de razas e iconos de clases y objetos
├── images/escenarios/            decorados en PNG (fondos y piezas de primer plano)
└── fonts/
tool/
├── escenarios/*.svg              originales editables de los decorados
└── generar_escenarios.sh         convierte los SVG en los PNG de assets/images/escenarios/
```

## Decorados
Cada pantalla es un `Stack` con tres capas: el fondo (`Image.asset`), el contenido con scroll y
unas pocas piezas de primer plano (cuerda, bambalina, bufanda, capa) colocadas con `Positioned`
**solo en los bordes**, para que nunca tapen el contenido. En la ficha final, el Checkbox enciende
el foco cambiando la opacidad de `foco.png` sobre `escenario.png`.

Para cambiar un decorado se edita su SVG en `tool/escenarios/` y se ejecuta
`bash tool/generar_escenarios.sh`, que necesita `rsvg-convert`.

**Concesiones de usar imágenes en vez de dibujarlas con código:**
- El fondo se ajusta al ancho de la pantalla. En pantallas muy altas, por debajo del decorado
  queda el color de fondo, y en las muy anchas se ve solo la parte de arriba.
- Cambiar el decorado implica editar el SVG y regenerar, no tocar Dart.
- Hay menos detalle que en el Figma (sin escalera, cables ni gelatinas de colores).
- Los PNG añaden unos 560 KB a la app.

## Datos y navegación
1. `GameData.load()` lee `assets/game_data.json` con `rootBundle.loadString`, que devuelve un `String`.
2. `jsonDecode` convierte ese texto en un `Map<String, dynamic>`. Sus claves `razas`, `clases` y
   `objetos` son listas de mapas.
3. Cada pantalla pide su sección en `initState` y, cuando llega, llama a `setState` para pintarla.
4. En `main.dart` se crea **un único** `CharacterData`. Se pasa por constructor de pantalla en pantalla
   con `Navigator.push`, así que todas modifican el mismo objeto y los datos se conservan al ir y volver.
5. En la ficha final, el botón de editar abre la pantalla correspondiente con `editMode: true`.
   Al guardar se hace `Navigator.pop` y la ficha se repinta con `setState`. "Nuevo" vuelve a la
   pantalla 1 con un personaje vacío (`pushAndRemoveUntil`).

## Reglas de atributos
- Todos los atributos empiezan en 10. El mínimo es 8 y el máximo 18.
- Hay 15 puntos para los físicos y otros 15 para los mentales.
  Puntos usados = suma de (valor − 10).
- El objeto equipado suma +2 al atributo indicado en su campo `bono`.
- Rango del hexágono: 18 = A, 16–17 = B, 14–15 = C, 12–13 = D, 11 o menos = E.

## Dónde se usa cada widget obligatorio
| Widget / mecanismo | Dónde | Para qué |
|---|---|---|
| Text, Icon | Todas | Textos; iconos de atributos, +/−, editar y flechas |
| Image.asset | Todas | Decorados, retrato de raza, iconos de clase y objeto (rutas tomadas del JSON) |
| Container, Padding | Todas | Tarjetas, paneles, rombos y esferas |
| Row, Column | Todas | Distribución general |
| Expanded | Barras de botones, filas de opción | Que el texto ocupe el espacio sobrante |
| Flexible | Atributos (P2, P3) y botones | Repartir los tres atributos sin desbordar |
| Wrap | P1 | Rejilla de 2 columnas con las razas |
| Stack | Todas (`StageScaffold`), tarjeta de raza, P4 | Decorado de fondo + contenido + primer plano; insignia ✓; foco y personaje sobre el escenario |
| SafeArea | `StageScaffold` y barra de botones | Respetar notch y barra del sistema |
| ListView | Todas (`StageScaffold`); `ListView.separated` en P3 | Scroll de la pantalla; lista de objetos |
| TextField + multilínea + TextEditingController | P1 | Nombre y biografía; el controlador conserva el texto al volver |
| GestureDetector | Tarjetas de raza (P1) y filas de opción (P2, P3) | Seleccionar tocando toda la tarjeta |
| IconButton | +/− de atributos (P2, P3) y editar (P4) | Ajustar valores y modificar elecciones |
| Radio (con RadioGroup) | P2 clases, P3 objetos | Selección única |
| DropdownButtonFormField | P3 | Filtrar objetos por tipo |
| Switch | P3 | Encender o apagar el foco que muestra el detalle del objeto |
| Slider | P3 | Faders de la mesa de luces para los atributos mentales |
| Checkbox | P4 | "Listo para el estreno": enciende el foco del escenario |
| onChanged + setState | Todas | Cada cambio actualiza el personaje y se ve al momento |

## Ejecutar
```bash
flutter pub get
flutter run
flutter test                                                     # tests de datos, reglas y recorrido completo
flutter test test_capturas/capturas_test.dart --update-goldens   # regenera docs/capturas_app/ (incluye ventanas 390x600 y 800x600)
```
