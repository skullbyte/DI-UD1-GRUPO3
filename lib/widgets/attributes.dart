import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Icono de cada atributo.
const Map<String, IconData> attributeIcons = {
  'Fuerza': Icons.fitness_center,
  'Agilidad': Icons.bolt,
  'Constitución': Icons.favorite,
  'Inteligencia': Icons.lightbulb,
  'Sabiduría': Icons.visibility,
  'Carisma': Icons.star,
};

/// Insignia de un atributo: forma con icono, nombre, valor y botones −/+.
/// - Físico: rombo rojo (un cuadrado girado 45°).
/// - Mental: círculo azul.
/// Si onMinus u onPlus son null, ese botón sale desactivado.
class AttributeBadge extends StatelessWidget {
  final String name;
  final int value;
  final bool physical;
  final bool showButtons;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  const AttributeBadge({
    super.key,
    required this.name,
    required this.value,
    required this.physical,
    this.showButtons = true,
    this.onMinus,
    this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    final color = physical ? AppColors.fisicoBorde : AppColors.mentalClaro;

    final Widget shape = physical
        ? Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.fisico,
                border: Border.all(color: color, width: 2),
              ),
            ),
          )
        : Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: AppColors.mental,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
          );

    return SizedBox(
      width: 104,
      child: Column(
        children: [
          // Stack: el icono va encima de la forma.
          SizedBox(
            height: 82,
            child: Stack(
              alignment: Alignment.center,
              children: [
                shape,
                Icon(attributeIcons[name], color: Colors.white, size: 30),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(name.toUpperCase(), style: AppText.atributo),
          if (showButtons)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _button(Icons.remove, onMinus, color),
                Text('$value', style: AppText.valor),
                _button(Icons.add, onPlus, color),
              ],
            )
          else
            Text('$value', style: AppText.valor),
        ],
      ),
    );
  }

  /// IconButton pequeño (28 px) para que quepan los dos botones y el número.
  /// shrinkWrap quita el margen extra que Material añade hasta 48 px.
  Widget _button(IconData icon, VoidCallback? onPressed, Color color) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      color: color,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
      style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
    );
  }
}
