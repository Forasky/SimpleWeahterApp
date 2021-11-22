import 'package:final_project/models/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(
          ThemeState(
            theme: ThemeMode.system,
            wasDark: ThemeMode.system == ThemeMode.dark ? true : false,
          ),
        );

  void changeLight() => emit(
        ThemeState(
          theme: ThemeMode.light,
          wasDark: false,
        ),
      );

  void changeDark() => emit(
        ThemeState(
          theme: ThemeMode.dark,
          wasDark: true,
        ),
      );
}