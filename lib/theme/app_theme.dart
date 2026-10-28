import 'package:flutter/material.dart';

/// Colores del diseño "Teatro" de Figma.
class AppColors {
  static const fondo = Color(0xFF120A0D);
  static const superficie = Color(0xFF1E1416);
  static const borde = Color(0xFF4A3428);
  static const seleccion = Color(0xFF4A0812);
  static const madera = Color(0xFF3A2417);
  static const oro = Color(0xFFD4A64A);
  static const oroClaro = Color(0xFFF2D27A);
  static const crema = Color(0xFFF3E6CC);
  static const suave = Color(0xFFB8A68A);
  static const oscuro = Color(0xFF1A0F08);
  static const fisico = Color(0xFF6E0B14);
  static const fisicoBorde = Color(0xFFA3202C);
  static const mental = Color(0xFF1D4E9E);
  static const mentalClaro = Color(0xFF6FB3FF);
}

/// Estilos de texto: Cinzel para títulos y Crimson Text para el cuerpo.
class AppText {
  static const acto = TextStyle(fontFamily: 'Cinzel', fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.oro);
  static const titulo = TextStyle(
    fontFamily: 'Cinzel',
    fontWeight: FontWeight.w900,
    fontSize: 26,
    color: AppColors.crema,
  );
  static const subtitulo = TextStyle(fontStyle: FontStyle.italic, fontSize: 15, color: AppColors.suave);
  static const seccion = TextStyle(
    fontFamily: 'Cinzel',
    fontWeight: FontWeight.w700,
    fontSize: 13,
    color: AppColors.oro,
  );
  static const opcion = TextStyle(
    fontFamily: 'Cinzel',
    fontWeight: FontWeight.w700,
    fontSize: 15,
    color: AppColors.crema,
  );
  static const atributo = TextStyle(
    fontFamily: 'Cinzel',
    fontWeight: FontWeight.w700,
    fontSize: 11,
    color: AppColors.crema,
  );
  static const valor = TextStyle(
    fontFamily: 'Cinzel',
    fontWeight: FontWeight.w900,
    fontSize: 22,
    color: AppColors.crema,
  );
  static const etiqueta = TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.oroClaro);
  static const cuerpo = TextStyle(fontSize: 16, color: AppColors.crema);
  static const descripcion = TextStyle(fontSize: 13, color: AppColors.suave);
}

/// Tema oscuro. Con primary = oro, los Radio, Checkbox y Switch ya salen dorados.
ThemeData buildTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'CrimsonText',
    scaffoldBackgroundColor: AppColors.fondo,
    colorScheme: const ColorScheme.dark(primary: AppColors.oro, surface: AppColors.superficie),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.oro, width: 1.5)),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.superficie,
      border: OutlineInputBorder(),
    ),
  );
}
