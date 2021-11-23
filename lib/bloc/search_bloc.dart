import 'dart:convert';
import 'package:final_project/models/searchBloc_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Cubit<SearchBlocState> {
  SearchBloc(SearchBlocState initialState) : super(initialState);
  final blocState = SearchBlocState();

  Future getText() async {
    if (blocState.items.isEmpty) {
      final text = await rootBundle.loadString('assets/cities/city_list.json');
      blocState.items = jsonDecode(text) as List<dynamic>;
      emit(
        SearchBlocState(
          foundUsers: blocState.items,
        ),
      );
    }
  }

  void resetChanges() {
    emit(
      SearchBlocState(
        foundUsers: blocState.items,
      ),
    );
  }

  void textChanged(String text) {
    List<dynamic> results = [];
    if (text.isEmpty) {
      results = blocState.items;
    } else {
      results = blocState.items
          .where(
              (city) => city["name"].toLowerCase().contains(text.toLowerCase()))
          .toList();
    }
    emit(
      SearchBlocState(foundUsers: results),
    );
  }
}
