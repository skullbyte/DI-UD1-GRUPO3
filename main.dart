import 'package:flutter/material.dart';

import 'models/character_data.dart';
import 'screens/screen1_identity.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const RPGCreatorApp());
}

class RPGCreatorApp extends StatelessWidget {
  const RPGCreatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Creador de Personaje RPG',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      // Un único CharacterData que viaja por las 4 pantallas (se pasa por constructor).
      home: Screen1Identity(character: CharacterData()),
    );
  }
}
