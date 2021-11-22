import 'package:moor/ffi.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';
import 'dart:io';
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
  AppDatebase() : super(_openConnection());

  int get schemaVersion => 2;

  Future<List<Task>> getAllTasks() => select(tasks).get();
  Stream<List<Task>> watchAllTasks() => select(tasks).watch();

  Future insertTask(Insertable<Task> task) => into(tasks).insert(task);
  Future deleteTask(Insertable<Task> task) => delete(tasks).delete(task);
}
