final String tableCity = 'City';

class CityFields {
  static final String id = '_id';
  static final String name = 'Name of City';
  static final String number = 'number';
  static final String temp = 'value of temp';
  static final String weather = 'what weather';
}

class City {
  final int? id;
  final String name;
  final int number;
  final int? temp;
  final String? weather;

  const City({
    this.id,
    required this.name,
    required this.number,
    this.temp,
    this.weather,
  });

  Map<String, dynamic> Convert() {
    return {
      '_id': id,
      'Name of City': name,
      'number': number,
      'value of temp': temp,
      'what weather': weather,
    };
  }

  @override
  String toString() {
    return 'City{_id: $id, Name of City: $name, number: $number, value of temp: $temp, what weather: $weather}';
  }
}
