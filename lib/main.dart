import 'package:easy_localization/easy_localization.dart';
import 'package:final_project/screens/main_screen.dart';
import 'package:final_project/screens/signup.dart';
import 'package:final_project/services/google_signin.dart';
import 'package:final_project/services/moor_database.dart';
import 'package:final_project/services/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
      WeatherClass(hasData: false),
    ),
  );
  GetIt.instance.registerSingleton<AllColors>(
    AllColors(nowText: Colors.black, nowTheme: Colors.white),
  );
  GetIt.instance.registerSingleton<SearchBloc>(
    SearchBloc(
      CityList(),
    ),
  );
  GetIt.instance.registerSingleton<TaskDao>(
    TaskDao(
      AppDatebase(),
    ),
  );
  GetIt.instance.registerSingleton<AuthenticationBloc>(AuthenticationBloc(GoogleSignInAccount));
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
          create: (BuildContext context) =>
              AuthenticationBloc(GoogleSignInAccount),
        ),
        BlocProvider<ThemeCubit>(
          create: (BuildContext context) => ThemeCubit(),
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
  @override
  Widget build(BuildContext context) {
    User? result = FirebaseAuth.instance.currentUser;
    return SplashScreen(
        useLoader: true,
        loadingTextPadding: EdgeInsets.all(0),
        loadingText: Text('welcome screen').tr(),
        navigateAfterSeconds: result != null ? MainScreen() : SignUp(),
        seconds: 5,
        title: Text('CloudApp'),
        image: Image.asset('assets/images/logo.png', fit: BoxFit.fill),
        backgroundColor: Colors.grey,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: () => print("Hi!"),
        loaderColor: Colors.grey);
  }
}
