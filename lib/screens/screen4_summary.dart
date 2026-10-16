import 'package:flutter/material.dart';

import '../models/character_data.dart';
import '../theme/app_theme.dart';
import '../widgets/attributes.dart';
import '../widgets/common.dart';
import 'screen1_identity.dart';
import 'screen2_class.dart';
import 'screen3_equipment.dart';

/// PANTALLA 4 · Ficha final (el teatro visto desde el público).
class Screen4Summary extends StatefulWidget {
  final CharacterData character;

  const Screen4Summary({super.key, required this.character});

  @override
  State<Screen4Summary> createState() => _Screen4SummaryState();
}

class _Screen4SummaryState extends State<Screen4Summary> {
  /// El Checkbox "listo para el estreno" enciende o apaga el foco del escenario.
  bool _listo = true;

  /// Abre una pantalla anterior en modo edición. Al volver (pop), setState repinta la ficha.
  Future<void> _edit(Widget screen) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    setState(() {});
  }

  /// Vuelve a la pantalla 1 con un personaje vacío y borra las pantallas anteriores.
  void _newCharacter() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => Screen1Identity(character: CharacterData())),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.character;
    final race = c.race!;
    final clase = c.characterClass!;
    final equipment = c.equipment!;

    return StageScaffold(
      buttons: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('MODIFICAR'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: GoldButton(text: 'NUEVO', icon: Icons.add, onPressed: _newCharacter)),
      ],
      children: [
        // Escenario: Stack con capas una encima de otra (escenario, foco, personaje y público).
        SizedBox(
          height: 360,
          child: Stack(
            children: [
              Positioned.fill(child: Image.asset('assets/images/escenarios/escenario.png', fit: BoxFit.fill)),
              if (_listo) Positioned.fill(child: Image.asset('assets/images/escenarios/foco.png', fit: BoxFit.fill)),
              Positioned(
                left: 0,
                right: 0,
                top: 150,
                child: Image.asset(race['imagen'], height: 120),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 100,
                child: Image.asset('assets/images/escenarios/publico.png', fit: BoxFit.fill),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Ficha del personaje.
        Panel(
          borderColor: AppColors.oro,
          child: Column(
            children: [
              const Text('ACTO IV · LA FUNCIÓN', style: AppText.acto),
              Text(c.name, textAlign: TextAlign.center, style: AppText.titulo),
              Text('${race['nombre']} · ${clase['nombre']}', style: AppText.subtitulo),
              if (c.biography.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('"${c.biography.trim()}"', textAlign: TextAlign.center, style: AppText.subtitulo),
                ),
              const SizedBox(height: 14),
              ChoiceRow(
                label: 'RAZA',
                value: race['nombre'],
                image: race['imagen'],
                onEdit: () => _edit(Screen1Identity(character: c, editMode: true)),
              ),
              ChoiceRow(
                label: 'CLASE',
                value: clase['nombre'],
                image: clase['imagen'],
                onEdit: () => _edit(Screen2Class(character: c, editMode: true)),
              ),
              ChoiceRow(
                label: 'EQUIPAMIENTO',
                value: equipment['nombre'],
                image: equipment['imagen'],
                onEdit: () => _edit(Screen3Equipment(character: c, editMode: true)),
              ),
              const SizedBox(height: 14),
              Text('ATRIBUTOS FÍSICOS', style: AppText.seccion.copyWith(color: AppColors.fisicoBorde)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (final name in c.physical.keys)
                    Flexible(
                      child: AttributeBadge(name: name, value: c.finalValue(name), physical: true, showButtons: false),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text('ATRIBUTOS MENTALES', style: AppText.seccion.copyWith(color: AppColors.mentalClaro)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (final name in c.mental.keys)
                    Flexible(
                      child: AttributeBadge(name: name, value: c.finalValue(name), physical: false, showButtons: false),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '${equipment['bono']} incluye +${CharacterData.equipmentBonus} de ${equipment['nombre']}',
                style: AppText.descripcion,
              ),
              Row(
                children: [
                  Checkbox(value: _listo, onChanged: (value) => setState(() => _listo = value!)),
                  const Expanded(child: Text('El personaje está listo para el estreno', style: AppText.cuerpo)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Fila de la ficha con imagen, elección y un IconButton para modificarla.
class ChoiceRow extends StatelessWidget {
  final String label;
  final String value;
  final String image;
  final VoidCallback onEdit;

  const ChoiceRow({super.key, required this.label, required this.value, required this.image, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.fondo,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borde),
      ),
      child: Row(
        children: [
          Image.asset(image, width: 40, height: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppText.descripcion),
                Text(value, style: AppText.opcion),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            tooltip: 'Modificar',
            icon: const Icon(Icons.edit, color: AppColors.oroClaro),
          ),
        ],
      ),
    );
  }
}
