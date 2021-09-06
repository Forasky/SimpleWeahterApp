import 'package:final_project/screens/main_screen.dart';
import 'package:final_project/screens/signup.dart';
import 'package:final_project/services/google_signin.dart';
import 'package:final_project/services/moor_database.dart';
import 'package:final_project/services/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => TempProvider()),
        Provider(create: (context) => AppDatebase().taskDao),
        ChangeNotifierProvider(create: (context) => Authentication()),
      ],
      child: MaterialApp(
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
        loadingText: Text('welcome screen'),
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
