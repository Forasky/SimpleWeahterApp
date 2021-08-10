import 'package:final_project/tables/city.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseClass {
  static final DatabaseClass instance = DatabaseClass._init();
  static Database _database;
  DatabaseClass._init();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB('cities.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

    await db.execute('''CREATE TABLE $tableCity (
      ${CityFields.id} $idType, ${CityFields.name} TEXT NOT NULL, ${CityFields.number} INTEGER)''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future insert(City city) async {
    final db = await database;
    await db.insert(tableCity, city.Convert());
  }

  Future<List<City>> getCity() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('City');
    return List.generate(maps.length, (i) {
      return City(
        id: maps[i]['uid'],
        name: maps[i]['Name of City'],
        number: maps[i]['number'],
      );
    });
  }

  Future<void> updateCity(City city) async {
    final db = await database;
    await db.update(tableCity, city.Convert(),
        where: 'uid=?', whereArgs: [CityFields.id]);
  }

  Future<void> deleteCity(int id) async {
    final db = await database;
    await db.delete(
      'City',
      where: 'uid = ?',
      whereArgs: [id],
    );
  }
}
