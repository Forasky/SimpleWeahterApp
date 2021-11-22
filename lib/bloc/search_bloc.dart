import 'dart:convert';
import 'package:final_project/models/cityList_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Cubit<CityList> {
  SearchBloc(CityList initialState) : super(initialState);
  final cl = CityList();

  Future getText() async {
    if (cl.items.isEmpty) {
      final text = await rootBundle.loadString('assets/cities/city_list.json');
      cl.items = jsonDecode(text) as List<dynamic>;
    }
    emit(
      CityList(
        foundUsers: cl.items,
      ),
    );
  }

  void resetChanges() {
    emit(
      CityList(
        foundUsers: cl.items,
      ),
    );
  }

  void textChanged(String text) {
    List<dynamic> results = [];
    if (text.isEmpty) {
      results = cl.items;
    } else {
      results = cl.items
          .where(
              (city) => city["name"].toLowerCase().contains(text.toLowerCase()))
          .toList();
    }
    emit(
      CityList(foundUsers: results),
    );
  }
}