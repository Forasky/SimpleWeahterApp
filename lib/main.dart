import 'package:final_project/screens/main_screen.dart';
import 'package:final_project/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Locales.init(['en', 'ru']);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (locale) => MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: Locales.delegates,
        supportedLocales: Locales.supportedLocales,
        locale: locale,
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
        loadingText: Text("All weather in your pocket"),
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
