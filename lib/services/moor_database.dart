import 'dart:convert';
import 'package:moor/ffi.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

part 'moor_database.g.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

LazyDatabase _openConnection() {
  return LazyDatabase(
    () async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));
      return VmDatabase(file);
    },
  );
}

@UseMoor(tables: [Tasks], daos: [TaskDao])
class AppDatebase extends _$AppDatebase {
  AppDatebase() : super(_openConnection());

  int get schemaVersion => 2;
}

@UseDao(tables: [Tasks])
class TaskDao extends DatabaseAccessor<AppDatebase> with _$TaskDaoMixin {
  final AppDatebase db;
  String msg = '';

  TaskDao(this.db) : super(db);

  Future<List<Task>> getAllTasks() => select(tasks).get();
  Stream<List<Task>> watchAllTasks() => select(tasks).watch();

  Future insertTask(Insertable<Task> task) => into(tasks).insert(task);
  Future updateTask(Insertable<Task> task) => update(tasks).replace(task);
  Future deleteTask(Insertable<Task> task) => delete(tasks).delete(task);

  Future<bool> checkName(String city) async {
    var results;
    http.Response responce = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=29e75f209ad00e2d850bcaf376406c7b&units=metric&lang=ru'));
    results = jsonDecode(responce.body);
    if (results['cod'] == "404" || results['cod'] == "400") {
      msg = "no data found";
      return false;
    } else {
      msg = "city was added";
      return true;
    }
  }
}
