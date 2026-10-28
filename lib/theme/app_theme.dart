import 'package:flutter/material.dart';

/// Colores de la colección "Teatro" del diseño en Figma.
class AppColors {
  static const escenaFondo = Color(0xFF120A0D);
  static const madera = Color(0xFF3A2417);
  static const maderaClara = Color(0xFF5C3A22);
  static const telonRojo = Color(0xFF7A1020);
  static const telonRojoOscuro = Color(0xFF4A0812);
  static const oro = Color(0xFFD4A64A);
  static const oroClaro = Color(0xFFF2D27A);
  static const crema = Color(0xFFF3E6CC);
  static const suave = Color(0xFFB8A68A);
  static const oscuro = Color(0xFF1A0F08);
  static const fisicoRojo = Color(0xFF6E0B14);
  static const fisicoBorde = Color(0xFFA3202C);
  static const mentalAzul = Color(0xFF1D4E9E);
  static const mentalAzulClaro = Color(0xFF6FB3FF);
  static const superficie = Color(0xFF1E1416);
  static const superficieBorde = Color(0xFF4A3428);
}

/// Estilos de texto: Cinzel para títulos y Crimson Text para el cuerpo.
class AppText {
  static const _cinzel = 'Cinzel';
  static const _crimson = 'CrimsonText';

  static const acto = TextStyle(
    fontFamily: _cinzel,
    fontWeight: FontWeight.w700,
    fontSize: 11,
    letterSpacing: 2.2,
    color: AppColors.oro,
  );
  static const titulo = TextStyle(
    fontFamily: _cinzel,
    fontWeight: FontWeight.w900,
    fontSize: 26,
    color: AppColors.crema,
  );
  static const subtitulo = TextStyle(
    fontFamily: _crimson,
    fontStyle: FontStyle.italic,
    fontSize: 15,
    color: AppColors.suave,
  );
  static const seccion = TextStyle(
    fontFamily: _cinzel,
    fontWeight: FontWeight.w700,
    fontSize: 13,
    letterSpacing: 1.8,
    color: AppColors.oro,
  );
  static const nombreOpcion = TextStyle(
    fontFamily: _cinzel,
    fontWeight: FontWeight.w700,
    fontSize: 15,
    color: AppColors.crema,
  );
  static const etiqueta = TextStyle(
    fontFamily: _crimson,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: AppColors.oroClaro,
  );
  static const cuerpo = TextStyle(fontFamily: _crimson, fontSize: 16, height: 1.3, color: AppColors.crema);
  static const descripcion = TextStyle(fontFamily: _crimson, fontSize: 13, height: 1.15, color: AppColors.suave);
  static const atributo = TextStyle(
    fontFamily: _cinzel,
    fontWeight: FontWeight.w700,
    fontSize: 11,
    letterSpacing: 0.9,
    color: AppColors.crema,
  );
  static const valor = TextStyle(
    fontFamily: _cinzel,
    fontWeight: FontWeight.w900,
    fontSize: 22,
    color: AppColors.crema,
  );
  static const boton = TextStyle(fontFamily: _cinzel, fontWeight: FontWeight.w700, fontSize: 15, letterSpacing: 0.9);
}

ThemeData buildTheatreTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'CrimsonText',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.oro,
      brightness: Brightness.dark,
      primary: AppColors.oro,
      secondary: AppColors.mentalAzulClaro,
      surface: AppColors.superficie,
    ),
    scaffoldBackgroundColor: AppColors.escenaFondo,
  );
  return base.copyWith(
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.superficie.withValues(alpha: 0.92),
      hintStyle: AppText.cuerpo.copyWith(color: AppColors.suave),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.superficieBorde, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.oro, width: 1.5),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? AppColors.oro : AppColors.suave,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? AppColors.oro : Colors.transparent,
      ),
      checkColor: const WidgetStatePropertyAll(AppColors.oscuro),
      side: const BorderSide(color: AppColors.oro, width: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? AppColors.oscuro : AppColors.suave,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? AppColors.oro : AppColors.superficieBorde,
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.mentalAzulClaro,
      inactiveTrackColor: AppColors.superficieBorde,
      thumbColor: Colors.white,
      overlayColor: Color(0x333F8CFF),
      trackHeight: 4,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.telonRojoOscuro,
      contentTextStyle: TextStyle(fontFamily: 'CrimsonText', fontSize: 15, color: AppColors.crema),
    ),
  );
}
