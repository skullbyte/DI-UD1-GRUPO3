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
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
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
    final razas = await GameData.razas();
    setState(() => _razas = razas);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _selectRace(Map<String, dynamic> raza) {
    setState(() => widget.character.race = raza);
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
    return StageScaffold(
      fondo: 'assets/images/escenarios/backstage.png',
      primerPlano: [
        Positioned(left: -10, top: 0, width: 28, child: Image.asset('assets/images/escenarios/cuerda.png')),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          width: 16,
          child: Image.asset('assets/images/escenarios/bambalina.png', fit: BoxFit.fill),
        ),
      ],
      bottomBar: ActionBar(
        children: [
          Expanded(
            child: TheatreButton(
              text: widget.editMode ? 'GUARDAR CAMBIOS' : 'IR AL VESTIDOR',
              icon: widget.editMode ? Icons.check : Icons.arrow_forward,
              onPressed: _continue,
            ),
          ),
        ],
      ),
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
          style: AppText.cuerpo,
          maxLength: 24,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'Aldric Tramoya', counterText: ''),
          onChanged: (value) => setState(() => widget.character.name = value),
        ),
        const SizedBox(height: 16),
        const Text('Biografía', style: AppText.etiqueta),
        const SizedBox(height: 6),
        TextField(
          controller: _bioController,
          style: AppText.cuerpo,
          minLines: 3,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(hintText: 'Criado entre bambalinas de un teatro ambulante...'),
          onChanged: (value) => widget.character.biography = value,
        ),
        const SectionTitle('ELIGE TU RAZA'),
        if (_razas.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator(color: AppColors.oro)),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = (constraints.maxWidth - 16) / 2;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final raza in _razas)
                    RaceCard(
                      raza: raza as Map<String, dynamic>,
                      width: cardWidth,
                      selected: race?['nombre'] == raza['nombre'],
                      onTap: () => _selectRace(raza),
                    ),
                ],
              );
            },
          ),
        if (race != null) ...[
          const SizedBox(height: 16),
          TheatrePanel(
            borderColor: AppColors.oro.withValues(alpha: 0.6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Has elegido: ${race['nombre']}', style: AppText.nombreOpcion.copyWith(color: AppColors.oroClaro)),
                const SizedBox(height: 6),
                Text(race['descripcion'], style: AppText.cuerpo.copyWith(fontSize: 14)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Tarjeta de raza (componente "Tarjeta/Raza"): retrato, nombre y descripción.
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
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: width,
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.telonRojoOscuro.withValues(alpha: 0.95)
                  : AppColors.superficie.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? AppColors.oroClaro : AppColors.superficieBorde,
                width: selected ? 2 : 1,
              ),
              boxShadow: selected
                  ? [BoxShadow(color: AppColors.oroClaro.withValues(alpha: 0.35), blurRadius: 18)]
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 110,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: RadialGradient(
                      colors: [selected ? const Color(0xFF8E1B26) : const Color(0xFF4A2A1C), const Color(0xFF1A0F0C)],
                    ),
                  ),
                  alignment: Alignment.bottomCenter,
                  child: Opacity(opacity: selected ? 1 : 0.6, child: Image.asset(raza['imagen'], height: 100)),
                ),
                const SizedBox(height: 6),
                Text(
                  raza['nombre'],
                  style: AppText.nombreOpcion.copyWith(
                    fontSize: 16,
                    color: selected ? AppColors.oroClaro : AppColors.crema,
                  ),
                ),
                const SizedBox(height: 2),
                Text(raza['descripcion'], style: AppText.descripcion, maxLines: 3, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          if (selected)
            Positioned(
              top: 14,
              right: 14,
              child: Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(color: AppColors.oro, shape: BoxShape.circle),
                child: const Icon(Icons.check, size: 18, color: AppColors.oscuro),
              ),
            ),
        ],
      ),
    );
  }
}
