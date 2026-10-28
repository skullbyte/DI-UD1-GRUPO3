/// Datos del personaje que se van rellenando a lo largo de las 4 pantallas.
/// Se crea una sola instancia en main.dart y se pasa por constructor
/// a las siguientes, así todas trabajan sobre el mismo objeto.
class CharacterData {
  // Reglas del reparto de atributos (iguales para físicos y mentales).
  static const int baseValue = 10;
  static const int minValue = 8;
  static const int maxValue = 18;
  static const int pointsPerGroup = 15;
  static const int equipmentBonus = 2;

  String name = '';
  String biography = '';

  // Cada elección es uno de los Map que vienen de game_data.json.
  Map<String, dynamic>? race;
  Map<String, dynamic>? characterClass;
  Map<String, dynamic>? equipment;

  // Atributo -> valor. Todos empiezan en baseValue (10).
  Map<String, int> physical = {'Fuerza': baseValue, 'Agilidad': baseValue, 'Constitución': baseValue};
  Map<String, int> mental = {'Inteligencia': baseValue, 'Sabiduría': baseValue, 'Carisma': baseValue};

  /// Puntos que quedan en un grupo: 15 menos lo que cada atributo está por encima de 10.
  int pointsAvailable(Map<String, int> group) {
    int used = 0;
    for (final value in group.values) {
      used += value - baseValue;
    }
    return pointsPerGroup - used;
  }

  /// Cambia un atributo respetando las reglas: entre 8 y 18 y sin gastar más puntos de los que quedan.
  void setAttribute(Map<String, int> group, String attribute, int newValue) {
    final current = group[attribute]!;
    int maxAllowed = current + pointsAvailable(group);
    if (maxAllowed > maxValue) maxAllowed = maxValue;
    group[attribute] = newValue.clamp(minValue, maxAllowed);
  }

  /// Valor final de un atributo sumando el bono del equipamiento
  /// (el campo "bono" de game_data.json indica a qué atributo afecta).
  int finalValue(String attribute) {
    final value = physical[attribute] ?? mental[attribute]!;
    if (equipment != null && equipment!['bono'] == attribute) {
      return value + equipmentBonus;
    }
    return value;
  }
}
