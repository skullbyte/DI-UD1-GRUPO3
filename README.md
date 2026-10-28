# Creador de personaje RPG

Proyecto Flutter de Desarrollo de Interfaces. La app crea un personaje en 4 pantallas
ambientadas en un teatro: cada pantalla es una zona distinta del escenario.

| Pantalla | Escenario | Contenido |
|---|---|---|
| 1. Identidad y raza | Backstage | Nombre, biografía y raza |
| 2. Clase y atributos físicos | Vestidor | Clase y Fuerza / Agilidad / Constitución (rombos rojos) |
| 3. Equipamiento y atributos mentales | Cabina de luces | Objeto e Inteligencia / Sabiduría / Carisma (círculos azules) |
| 4. Ficha final | Teatro visto desde el público | Resumen, atributos finales y opciones para modificar |

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
    └── attributes.dart           AttributeBadge: rombo (físico) o círculo (mental)
assets/
├── game_data.json                Datos de razas, clases y objetos
├── images/
│   ├── humano.png, elfo.png, enano.png, orco.png      Retratos de las razas
│   ├── clases/                   guerrero, mago, picaro, clerigo (.png)
│   ├── objetos/                  espada_larga, baston_arcano, dagas_gemelas,
│   │                             armadura_placas, amuleto_sabiduria, capa_elfica (.png)
│   └── escenarios/
│       ├── backstage.png         Fondo de la pantalla 1
│       ├── vestidor.png          Fondo de la pantalla 2
│       ├── cabina.png            Fondo de la pantalla 3
│       ├── escenario.png         Escenario de la ficha final (pantalla 4)
│       ├── foco.png              Luz que enciende el Checkbox de la ficha
│       └── publico.png           Siluetas del público delante del escenario
└── fonts/
    ├── Cinzel-Bold.ttf, Cinzel-Black.ttf                 Títulos
    └── CrimsonText-Regular / Italic / SemiBold.ttf       Texto normal
test/
└── widget_test.dart              Lectura del JSON, reglas de puntos y recorrido completo
docs/
├── figma/                        Capturas del diseño en Figma
└── capturas_app/                 Capturas de la app
tool/
├── escenarios/*.svg              Originales editables de los fondos
└── generar_escenarios.sh         Convierte los SVG en los PNG de assets/images/escenarios/
```

## Decorados
Cada pantalla usa `StageScaffold`: un `Stack` con la imagen de fondo (`Image.asset`) y, encima,
el contenido con scroll (`ListView`). Los botones van en `bottomNavigationBar`.
En la ficha final, el Checkbox enciende el foco mostrando u ocultando `foco.png` sobre `escenario.png`.

Para cambiar un decorado se edita su SVG en `tool/escenarios/` y se ejecuta
`bash tool/generar_escenarios.sh`, que necesita `rsvg-convert`.

## Datos y navegación
1. `loadSection('razas')` lee `assets/game_data.json` con `rootBundle.loadString`, que devuelve un `String`.
2. `jsonDecode` convierte ese texto en un `Map<String, dynamic>`. Sus claves `razas`, `clases` y
   `objetos` son listas de mapas; la función devuelve la lista pedida.
3. Cada pantalla pide su sección en `initState` y, cuando llega, llama a `setState` para pintarla.
4. En `main.dart` se crea **un único** `CharacterData`. Se pasa por constructor de pantalla en pantalla
   con `Navigator.push`, así que todas modifican el mismo objeto y los datos se conservan al ir y volver.
5. En la ficha final, el botón de editar abre la pantalla correspondiente con `editMode: true`.
   Al guardar se hace `Navigator.pop` y la ficha se repinta con `setState`. "Nuevo" vuelve a la
   pantalla 1 con un personaje vacío (`pushAndRemoveUntil`).

## Reglas de atributos
- Los atributos se guardan en dos `Map<String, int>`: `physical` y `mental`.
- Todos empiezan en 10. El mínimo es 8 y el máximo 18.
- Hay 15 puntos para los físicos y otros 15 para los mentales.
  Puntos usados = suma de (valor − 10). Lo calcula `pointsAvailable(grupo)`.
- `setAttribute(grupo, atributo, valor)` aplica las reglas (lo usan los botones +/− y los Slider).
- El objeto equipado suma +2 al atributo indicado en su campo `bono` (`finalValue`).

## Dónde se usa cada widget obligatorio
| Widget / mecanismo | Dónde | Para qué |
|---|---|---|
| Text, Icon | Todas | Textos; iconos de atributos, +/−, editar y flechas |
| Image.asset | Todas | Decorados, retrato de raza, iconos de clase y objeto (rutas tomadas del JSON) |
| Container, Padding | Todas | Tarjetas, paneles, rombos y círculos |
| Row, Column | Todas | Distribución general |
| Expanded | Barras de botones, filas de opción | Que el texto ocupe el espacio sobrante |
| Flexible | Filas de atributos (P2, P3, P4) | Repartir los tres atributos sin desbordar |
| Wrap | P1 | Rejilla de 2 columnas con las razas |
| Stack | Todas (`StageScaffold`), tarjeta de raza, insignias de atributo, P4 | Fondo + contenido; ✓ encima de la tarjeta; icono sobre el rombo/círculo; foco y personaje sobre el escenario |
| SafeArea | `StageScaffold` (contenido y botones) | Respetar notch y barra del sistema |
| ListView | Todas (`StageScaffold`); `ListView.builder` en P3 | Scroll de la pantalla; lista de objetos |
| TextField + multilínea + TextEditingController | P1 | Nombre y biografía; el controlador conserva el texto al volver |
| GestureDetector | Tarjetas de raza (P1) y filas de opción (P2, P3) | Seleccionar tocando toda la tarjeta |
| IconButton | +/− de atributos (P2, P3) y editar (P4) | Ajustar valores y modificar elecciones |
| Radio (con RadioGroup) | P2 clases, P3 objetos | Selección única: RadioGroup guarda cuál está marcado |
| DropdownButtonFormField | P3 | Filtrar objetos por tipo |
| Switch | P3 | Encender o apagar el foco que muestra el detalle del objeto |
| Slider | P3 | Faders de la mesa de luces para los atributos mentales |
| Checkbox | P4 | "Listo para el estreno": enciende el foco del escenario |
| onChanged + setState | Todas | Cada cambio actualiza el personaje y se ve al momento |

## Ejecutar
```bash
flutter pub get
flutter run
flutter test   # comprueba el JSON, las reglas de puntos y el recorrido completo
```
