import 'package:final_project/models/change_temp_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ChangeTempBloc extends Cubit<TempState> {
  final locate = GetIt.instance;
  ChangeTempBloc()
      : super(
          TempState(
            temp: 'metric',
            wasImperial: false,
          ),
        );

  void changeMetric() => emit(
        TempState(
          temp: 'metric',
          wasImperial: false,
        ),
      );

  void changeFarengeit() => emit(
        TempState(
          temp: 'imperial',
          wasImperial: true,
        ),
      );
}