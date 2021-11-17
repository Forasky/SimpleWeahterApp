import 'package:easy_localization/easy_localization.dart';
import 'package:final_project/screens/main_screen.dart';
import 'package:final_project/screens/signup.dart';
import 'package:final_project/services/autorization_bloc.dart';
import 'package:final_project/services/moor_database.dart';
import 'package:final_project/services/bloc.dart';
import 'package:final_project/services/weather_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  GetIt.instance.registerSingleton<ChangeTempBloc>(
    ChangeTempBloc(),
  );
  GetIt.instance.registerSingleton<TempBloc>(
    TempBloc(
      Temperature(
        current: Current(
            dt: DateTime.now(),
            feelsLike: 0,
            humidity: 0,
            pressure: 0,
            temp: 0,
            weather: [],
            windSpeed: 0),
        daily: [],
        hasData: false,
        hourly: [],
      ),
    ),
  );
  GetIt.instance.registerSingleton<SearchBloc>(
    SearchBloc(
      CityList(),
    ),
  );
  GetIt.instance.registerSingleton<DatabaseBloc>(
    DatabaseBloc(''),
  );
  GetIt.instance.registerSingleton<AuthenticationBloc>(
    AuthenticationBloc(
      Credits(
        message: '',
        isLogin: false,
      ),
    ),
  );
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ru')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(
            Credits(
              message: '',
              isLogin: false,
            ),
          ),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: IntroScreen(),
      ),
    );
  }
}

class IntroScreen extends StatelessWidget {
  final auth = GetIt.instance.get<AuthenticationBloc>();

  @override
  Widget build(BuildContext context) {
    getLogin();
    return SplashScreen(
        useLoader: true,
        loadingTextPadding: EdgeInsets.all(0),
        loadingText: Text('welcome screen').tr(),
        navigateAfterSeconds: auth.state.isLogin ? MainScreen() : SignUp(),
        seconds: 5,
        title: Text('CloudApp'),
        image: Image.asset('assets/images/logo.png', fit: BoxFit.fill),
        backgroundColor: Colors.grey,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: () => print("Hi!"),
        loaderColor: Colors.grey);
  }

  Future getLogin() async {
    await auth.checkSignIn();
  }
}
