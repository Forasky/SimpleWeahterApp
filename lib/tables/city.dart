final String tableCity = 'City';

class CityFields {
  static final String id = 'uid';
  static final String name = 'Name of City';
  static final String number = 'number';
}

class City {
  final int id;
  final String name;
  final int number;

  const City({
    this.id,
    this.name,
    this.number,
  });

  Map<String, dynamic> Convert() {
    return {
      'uid': id,
      'Name of City': name,
      'number': number,
    };
  }

  @override
  String toString() {
    return 'City{uid: $id, Name of City: $name, number: $number}';
  }
}
