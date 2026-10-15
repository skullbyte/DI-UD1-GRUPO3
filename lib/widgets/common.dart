import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Estructura común de las pantallas: Stack con la imagen de decorado de fondo,
/// el contenido con scroll (ListView) por encima y los botones abajo.
class StageScaffold extends StatelessWidget {
  final String? background;
  final List<Widget> children;
  final List<Widget> buttons;

  const StageScaffold({super.key, this.background, required this.children, required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (background != null)
            Image.asset(background!, width: double.infinity, fit: BoxFit.fitWidth, alignment: Alignment.topCenter),
          SafeArea(
            child: ListView(padding: const EdgeInsets.all(16), children: children),
          ),
        ],
      ),
      // Barra inferior con los botones de navegación.
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: buttons),
        ),
      ),
    );
  }
}

/// Botón dorado principal (continuar, guardar...).
class GoldButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const GoldButton({super.key, required this.text, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
      iconAlignment: IconAlignment.end,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.oro,
        foregroundColor: AppColors.oscuro,
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontFamily: 'Cinzel', fontWeight: FontWeight.w700, fontSize: 15),
      ),
    );
  }
}

/// Botón con borde dorado para volver atrás.
class BackButtonOutlined extends StatelessWidget {
  const BackButtonOutlined({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: OutlinedButton(
        onPressed: () => Navigator.pop(context),
        style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}

/// Cabecera de cada pantalla: "ACTO X", título, subtítulo y progreso (4 pasos).
class ActHeader extends StatelessWidget {
  final String act;
  final String title;
  final String subtitle;
  final int step;

  const ActHeader({super.key, required this.act, required this.title, required this.subtitle, required this.step});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(act, style: AppText.acto),
        Text(title, style: AppText.titulo, textAlign: TextAlign.center),
        Text(subtitle, style: AppText.subtitulo, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 1; i <= 4; i++)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == step ? 28 : 10,
                height: 6,
                color: i <= step ? AppColors.oro : AppColors.borde,
              ),
          ],
        ),
      ],
    );
  }
}

/// Título de sección con un widget opcional a la derecha (los puntos).
class SectionTitle extends StatelessWidget {
  final String text;
  final Widget? trailing;

  const SectionTitle(this.text, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(text, style: AppText.seccion)),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Píldora "5 / 15 puntos": roja para los físicos y azul para los mentales.
class PointsBadge extends StatelessWidget {
  final int available;
  final bool physical;

  const PointsBadge({super.key, required this.available, required this.physical});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: physical ? AppColors.fisico : AppColors.mental,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text('$available / 15 puntos', style: AppText.atributo),
    );
  }
}

/// Panel oscuro con borde para agrupar información.
class Panel extends StatelessWidget {
  final Widget child;
  final Color borderColor;

  const Panel({super.key, required this.child, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.superficie,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}

/// Fila seleccionable para clases y objetos: icono, nombre, descripción y un control a la derecha.
/// Con GestureDetector se puede tocar toda la fila, no solo el Radio.
class OptionRow extends StatelessWidget {
  final String name;
  final String description;
  final String image;
  final bool selected;
  final VoidCallback onTap;
  final Widget trailing;

  const OptionRow({
    super.key,
    required this.name,
    required this.description,
    required this.image,
    required this.selected,
    required this.onTap,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? AppColors.seleccion : AppColors.superficie,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? AppColors.oroClaro : AppColors.borde, width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: selected ? AppColors.oro : AppColors.madera,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(image, color: selected ? AppColors.oscuro : Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppText.opcion),
                  Text(description, style: AppText.descripcion),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
