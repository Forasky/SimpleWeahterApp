final String tableCity = 'City';

class CityFields {
  static final String id = '_id';
  static final String name = 'Name';
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

  Map<String, dynamic> convert() {
    return {
      CityFields.id: id,
      CityFields.name: name,
      CityFields.number: number,
    };
  }

  @override
  String toString() {
    return 'City{${CityFields.id}: $id, ${CityFields.name}: $name, ${CityFields.number} $number}';
  }
}
