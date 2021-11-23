import 'dart:convert';
import 'package:final_project/models/database_model.dart';
import 'package:final_project/models/cityList_model.dart';
import 'package:final_project/services/helping_classes.dart';
import 'package:final_project/services/moor_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';
import 'package:http/http.dart' as http;

class DatabaseBloc extends Cubit<DatabaseBlocState> {
  final datebase = AppDatebase();
  List<String> items = [];

  DatabaseBloc(DatabaseBlocState initialState) : super(initialState);

  Future<bool> checkName(String city) async {
    var results;
    final responce = await http.get(Uri.parse(
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
        DatabaseBlocState(
          message: LocalizationKeys.cityAdded,
          listCity: items,
        ),
      );
      Future.delayed(
        const Duration(seconds: 2),
        () => emit(
          DatabaseBlocState(
            message: '',
            listCity: items,
          ),
        ),
      );
    } else
      emit(
        DatabaseBlocState(
          message: LocalizationKeys.noDataFound,
          listCity: items,
        ),
      );
  }

  void deleteTask(Insertable<Task> task) {
    datebase.deleteTask(task);
  }

  Future getText() async {
    if (items.isEmpty) {
      final text = await rootBundle.loadString('assets/cities/city.json');
      Map<String, dynamic> json = await jsonDecode(text);
      final model = CityList.fromJson(json);
      model.city.forEach(
        (e) => items.add(e.name),
      );
      emit(
        DatabaseBlocState(
          message: '',
          listCity: items,
        ),
      );
    }
  }

  void resetChanges() {
    emit(
      DatabaseBlocState(
        message: '',
        listCity: items,
      ),
    );
  }

  void textChanged(String text) {
    List<String> results = [];
    if (text.isEmpty) {
      results = items;
    } else {
      results = items
          .where(
            (city) => city.toLowerCase().contains(
                  text.toLowerCase(),
                ),
          )
          .toList();
    }
    emit(
      DatabaseBlocState(
        message: '',
        listCity: results,
      ),
    );
  }
}
