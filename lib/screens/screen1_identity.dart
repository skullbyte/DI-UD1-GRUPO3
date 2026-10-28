import 'package:flutter/material.dart';

import '../data/game_data.dart';
import '../models/character_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'screen2_class.dart';

/// PANTALLA 1 · Identidad y raza (Backstage).
class Screen1Identity extends StatefulWidget {
  final CharacterData character;

  /// true cuando se abre desde la ficha final para modificar: el botón guarda y vuelve.
  final bool editMode;

  const Screen1Identity({super.key, required this.character, this.editMode = false});

  @override
  State<Screen1Identity> createState() => _Screen1IdentityState();
}

class _Screen1IdentityState extends State<Screen1Identity> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  List<dynamic> _razas = [];

  @override
  void initState() {
    super.initState();
    // Los controladores empiezan con lo que ya tenga el personaje (por si volvemos atrás).
    _nameController = TextEditingController(text: widget.character.name);
    _bioController = TextEditingController(text: widget.character.biography);
    _loadRazas();
  }

  Future<void> _loadRazas() async {
    final razas = await loadSection('razas');
    setState(() => _razas = razas);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _continue() {
    final c = widget.character;
    if (c.name.trim().isEmpty || c.race == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Escribe un nombre y elige una raza antes de salir a escena.')));
      return;
    }
    if (widget.editMode) {
      Navigator.pop(context);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => Screen2Class(character: c)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final race = widget.character.race;
    // Dos tarjetas por fila: ancho de pantalla menos márgenes (16 + 16) y hueco central (16).
    final cardWidth = (MediaQuery.of(context).size.width - 48) / 2;

    return StageScaffold(
      background: 'assets/images/escenarios/backstage.png',
      buttons: [
        Expanded(
          child: GoldButton(
            text: widget.editMode ? 'GUARDAR CAMBIOS' : 'IR AL VESTIDOR',
            icon: widget.editMode ? Icons.check : Icons.arrow_forward,
            onPressed: _continue,
          ),
        ),
      ],
      children: [
        const ActHeader(
          act: 'ACTO I · BACKSTAGE',
          title: 'Identidad y Raza',
          subtitle: 'Antes de salir a escena, ¿quién eres?',
          step: 1,
        ),
        const SizedBox(height: 20),
        const Text('Nombre del personaje', style: AppText.etiqueta),
        const SizedBox(height: 6),
        TextField(
          controller: _nameController,
          maxLength: 24,
          decoration: const InputDecoration(hintText: 'Aldric Tramoya', counterText: ''),
          onChanged: (value) => widget.character.name = value,
        ),
        const SizedBox(height: 16),
        const Text('Biografía', style: AppText.etiqueta),
        const SizedBox(height: 6),
        // TextField multilínea: de 3 a 5 líneas visibles.
        TextField(
          controller: _bioController,
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(hintText: 'Criado entre bambalinas de un teatro ambulante...'),
          onChanged: (value) => widget.character.biography = value,
        ),
        const SectionTitle('ELIGE TU RAZA'),
        // Wrap coloca las tarjetas en filas y salta de línea cuando no caben.
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final raza in _razas)
              RaceCard(
                raza: raza,
                width: cardWidth,
                selected: race?['nombre'] == raza['nombre'],
                onTap: () => setState(() => widget.character.race = raza),
              ),
          ],
        ),
        if (race != null) ...[
          const SizedBox(height: 16),
          Panel(
            borderColor: AppColors.oro,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Has elegido: ${race['nombre']}', style: AppText.opcion.copyWith(color: AppColors.oroClaro)),
                Text(race['descripcion'], style: AppText.cuerpo),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Tarjeta de raza: imagen, nombre y descripción. Si está elegida, borde dorado y ✓ encima.
class RaceCard extends StatelessWidget {
  final Map<String, dynamic> raza;
  final double width;
  final bool selected;
  final VoidCallback onTap;

  const RaceCard({super.key, required this.raza, required this.width, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: width,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selected ? AppColors.seleccion : AppColors.superficie,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: selected ? AppColors.oroClaro : AppColors.borde, width: selected ? 2 : 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.asset(raza['imagen'], height: 100)),
                const SizedBox(height: 6),
                Text(raza['nombre'], style: AppText.opcion),
                Text(raza['descripcion'], style: AppText.descripcion, maxLines: 3, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          if (selected)
            const Positioned(top: 12, right: 12, child: Icon(Icons.check_circle, color: AppColors.oro, size: 28)),
        ],
      ),
    );
  }
}
