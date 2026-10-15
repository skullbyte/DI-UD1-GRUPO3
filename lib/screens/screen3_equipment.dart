import 'package:flutter/material.dart';

import '../data/game_data.dart';
import '../models/character_data.dart';
import '../theme/app_theme.dart';
import '../widgets/attributes.dart';
import '../widgets/common.dart';
import 'screen4_summary.dart';

/// PANTALLA 3 · Equipamiento y atributos mentales (Cabina de luces).
class Screen3Equipment extends StatefulWidget {
  final CharacterData character;
  final bool editMode;

  const Screen3Equipment({super.key, required this.character, this.editMode = false});

  @override
  State<Screen3Equipment> createState() => _Screen3EquipmentState();
}

class _Screen3EquipmentState extends State<Screen3Equipment> {
  List<dynamic> _objetos = [];
  String _filtro = 'Todos';
  bool _focoEncendido = true;

  @override
  void initState() {
    super.initState();
    _loadObjetos();
  }

  Future<void> _loadObjetos() async {
    final objetos = await loadSection('objetos');
    setState(() => _objetos = objetos);
  }

  void _selectItem(Map<String, dynamic> objeto) {
    setState(() => widget.character.equipment = objeto);
  }

  void _setMental(String name, int value) {
    setState(() => widget.character.setAttribute(widget.character.mental, name, value));
  }

  void _continue() {
    if (widget.character.equipment == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Elige un objeto de equipamiento antes de salir a escena.')));
      return;
    }
    if (widget.editMode) {
      Navigator.pop(context);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => Screen4Summary(character: widget.character)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.character;
    final equipment = c.equipment;
    final available = c.pointsAvailable(c.mental);
    // Objetos que se ven según el filtro del Dropdown.
    final visibles = _filtro == 'Todos' ? _objetos : _objetos.where((o) => o['tipo'] == _filtro).toList();

    return StageScaffold(
      background: 'assets/images/escenarios/cabina.png',
      buttons: [
        if (!widget.editMode) const BackButtonOutlined(),
        Expanded(
          child: GoldButton(
            text: widget.editMode ? 'GUARDAR CAMBIOS' : '¡A ESCENA!',
            icon: widget.editMode ? Icons.check : Icons.arrow_forward,
            onPressed: _continue,
          ),
        ),
      ],
      children: [
        const ActHeader(
          act: 'ACTO III · CABINA DE LUCES',
          title: 'Equipo y Mente',
          subtitle: 'Ajusta los focos de tu ingenio antes del estreno',
          step: 3,
        ),
        const SizedBox(height: 20),
        const Text('Filtrar por tipo', style: AppText.etiqueta),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: _filtro,
          items: const [
            DropdownMenuItem(value: 'Todos', child: Text('Todos los objetos')),
            DropdownMenuItem(value: 'Arma', child: Text('Arma')),
            DropdownMenuItem(value: 'Defensa', child: Text('Defensa')),
            DropdownMenuItem(value: 'Accesorio', child: Text('Accesorio')),
          ],
          onChanged: (value) => setState(() => _filtro = value!),
        ),
        const SectionTitle('ELIGE TU EQUIPAMIENTO'),
        RadioGroup<String>(
          groupValue: equipment?['nombre'],
          onChanged: (nombre) => _selectItem(_objetos.firstWhere((o) => o['nombre'] == nombre)),
          // ListView.builder crea una fila por cada objeto de la lista.
          // shrinkWrap + NeverScrollable: el scroll lo hace el ListView de la pantalla.
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: visibles.length,
            itemBuilder: (context, index) {
              final objeto = visibles[index];
              return OptionRow(
                name: objeto['nombre'],
                description: '${objeto['tipo']} · +${CharacterData.equipmentBonus} ${objeto['bono']}',
                image: objeto['imagen'],
                selected: equipment?['nombre'] == objeto['nombre'],
                onTap: () => _selectItem(objeto),
                trailing: Radio<String>(value: objeto['nombre']),
              );
            },
          ),
        ),
        Row(
          children: [
            const Expanded(child: Text('Encender foco sobre el objeto', style: AppText.cuerpo)),
            Switch(value: _focoEncendido, onChanged: (value) => setState(() => _focoEncendido = value)),
          ],
        ),
        // El Switch muestra u oculta el detalle del objeto elegido.
        if (_focoEncendido && equipment != null)
          Panel(
            borderColor: AppColors.mentalClaro,
            child: Row(
              children: [
                Image.asset(equipment['imagen'], width: 56, color: AppColors.oroClaro),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(equipment['nombre'], style: AppText.opcion.copyWith(color: AppColors.oroClaro)),
                      Text('TIPO: ${equipment['tipo']}'.toUpperCase(), style: AppText.descripcion),
                      Text(
                        '${equipment['descripcion']} Bonificación: +${CharacterData.equipmentBonus} ${equipment['bono']}.',
                        style: AppText.cuerpo,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        SectionTitle('ATRIBUTOS MENTALES', trailing: PointsBadge(available: available, physical: false)),
        Panel(
          borderColor: AppColors.mentalClaro,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (final name in c.mental.keys)
                    Flexible(
                      child: AttributeBadge(
                        physical: false,
                        name: name,
                        value: c.mental[name]!,
                        onMinus: c.mental[name]! > CharacterData.minValue
                            ? () => _setMental(name, c.mental[name]! - 1)
                            : null,
                        onPlus: c.mental[name]! < CharacterData.maxValue && available > 0
                            ? () => _setMental(name, c.mental[name]! + 1)
                            : null,
                      ),
                    ),
                ],
              ),
              // Un Slider por atributo (los "faders" de la mesa de luces).
              for (final name in c.mental.keys)
                Row(
                  children: [
                    SizedBox(width: 40, child: Text(name.substring(0, 3).toUpperCase(), style: AppText.atributo)),
                    Expanded(
                      child: Slider(
                        value: c.mental[name]!.toDouble(),
                        min: 8,
                        max: 18,
                        divisions: 10,
                        label: '${c.mental[name]}',
                        activeColor: AppColors.mentalClaro,
                        onChanged: (v) => _setMental(name, v.round()),
                      ),
                    ),
                  ],
                ),
              const Text('Base 10 · mínimo 8 · máximo 18 por atributo', style: AppText.descripcion),
            ],
          ),
        ),
      ],
    );
  }
}
