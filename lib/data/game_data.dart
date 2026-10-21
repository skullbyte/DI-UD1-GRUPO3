import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// Lee una sección ('razas', 'clases' u 'objetos') de assets/game_data.json.
///
/// 1. rootBundle.loadString devuelve el archivo como un String.
/// 2. jsonDecode convierte ese texto en un `Map<String, dynamic>`.
/// 3. Cada sección del Map es una List de Maps (un Map por raza, clase u objeto).
Future<List<dynamic>> loadSection(String section) async {
  final String text = await rootBundle.loadString('assets/game_data.json');
  final Map<String, dynamic> data = jsonDecode(text);
  return data[section];
}
