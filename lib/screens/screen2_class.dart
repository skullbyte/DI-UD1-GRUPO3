import 'package:flutter/material.dart';

import '../data/game_data.dart';
import '../models/character_data.dart';
import '../theme/app_theme.dart';
import '../widgets/attributes.dart';
import '../widgets/common.dart';
import 'screen3_equipment.dart';

/// PANTALLA 2 · Clase y atributos físicos (Vestidor).
class Screen2Class extends StatefulWidget {
  final CharacterData character;
  final bool editMode;

  const Screen2Class({super.key, required this.character, this.editMode = false});

  @override
  State<Screen2Class> createState() => _Screen2ClassState();
}

class _Screen2ClassState extends State<Screen2Class> {
  List<dynamic> _clases = [];

  @override
  void initState() {
    super.initState();
    _loadClases();
  }

  Future<void> _loadClases() async {
    final clases = await loadSection('clases');
    setState(() => _clases = clases);
  }

  void _selectClass(Map<String, dynamic> clase) {
    setState(() => widget.character.characterClass = clase);
  }

  void _continue() {
    if (widget.character.characterClass == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Elige una clase antes de pasar a la cabina de luces.')));
      return;
    }
    if (widget.editMode) {
      Navigator.pop(context);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => Screen3Equipment(character: widget.character)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.character;
    final available = c.pointsAvailable(c.physical);

    return StageScaffold(
      background: 'assets/images/escenarios/vestidor.png',
      buttons: [
        if (!widget.editMode) const BackButtonOutlined(),
        Expanded(
          child: GoldButton(
            text: widget.editMode ? 'GUARDAR CAMBIOS' : 'A LA CABINA DE LUCES',
            icon: widget.editMode ? Icons.check : Icons.arrow_forward,
            onPressed: _continue,
          ),
        ),
      ],
      children: [
        const ActHeader(
          act: 'ACTO II · VESTIDOR',
          title: 'Clase y Atributos',
          subtitle: 'Elige tu vestuario y prepara el cuerpo para la función',
          step: 2,
        ),
        const SectionTitle('ELIGE TU CLASE'),
        // RadioGroup guarda qué Radio está marcado: solo puede haber una clase.
        RadioGroup<String>(
          groupValue: c.characterClass?['nombre'],
          onChanged: (nombre) => _selectClass(_clases.firstWhere((clase) => clase['nombre'] == nombre)),
          child: Column(
            children: [
              for (final clase in _clases)
                OptionRow(
                  name: clase['nombre'],
                  description: clase['descripcion'],
                  image: clase['imagen'],
                  selected: c.characterClass?['nombre'] == clase['nombre'],
                  onTap: () => _selectClass(clase),
                  trailing: Radio<String>(value: clase['nombre']),
                ),
            ],
          ),
        ),
        SectionTitle('ATRIBUTOS FÍSICOS', trailing: PointsBadge(available: available, physical: true)),
        Panel(
          borderColor: AppColors.fisicoBorde,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (final name in c.physical.keys)
                    Flexible(
                      child: AttributeBadge(
                        physical: true,
                        name: name,
                        value: c.physical[name]!,
                        // null desactiva el botón: no se baja de 8 ni se sube de 18 o sin puntos.
                        onMinus: c.physical[name]! > CharacterData.minValue
                            ? () => setState(() => c.setAttribute(c.physical, name, c.physical[name]! - 1))
                            : null,
                        onPlus: c.physical[name]! < CharacterData.maxValue && available > 0
                            ? () => setState(() => c.setAttribute(c.physical, name, c.physical[name]! + 1))
                            : null,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Base 10 · mínimo 8 · máximo 18. Te quedan $available de 15 puntos.',
                textAlign: TextAlign.center,
                style: AppText.descripcion,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
