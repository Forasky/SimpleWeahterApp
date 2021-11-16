import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
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

@UseMoor(tables: [Tasks])
class AppDatebase extends _$AppDatebase {
  AppDatebase(this.msg) : super(_openConnection());
  String msg;

  int get schemaVersion => 2;

  Future<List<Task>> getAllTasks() => select(tasks).get();
  Stream<List<Task>> watchAllTasks() => select(tasks).watch();

  Future insertTask(Insertable<Task> task) => into(tasks).insert(task);
  Future deleteTask(Insertable<Task> task) => delete(tasks).delete(task);
}

class DatabaseBloc extends Cubit<AppDatebase> {
  AppDatebase datebase = AppDatebase('');
  String msg;

  DatabaseBloc(this.msg) : super(AppDatebase(''));

  Future<bool> checkName(String city) async {
    var results;
    http.Response responce = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=29e75f209ad00e2d850bcaf376406c7b&units=metric&lang=ru'));
    results = jsonDecode(responce.body);
    if (results['cod'] == "404" || results['cod'] == "400")
      return false;
    else
      return true;
  }

  Future getTasks() async {
    datebase.getAllTasks();
  }

  void insertTask(String city) async {
    final task = TasksCompanion(
      name: Value(city),
    );
    if (await checkName(city)) {
      datebase.insertTask(task);
      emit(
        AppDatebase('city was added'),
      );
      Future.delayed(
        const Duration(seconds: 2),
        () => emit(AppDatebase('')),
      );
    } else
      emit(
        AppDatebase('no data found'),
      );
  }

  void deleteTask(Insertable<Task> task) {
    datebase.deleteTask(task);
  }
}
