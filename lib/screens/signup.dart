// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:final_project/bloc/autorization_bloc.dart';
import 'package:final_project/screens/main_screen.dart';
import 'package:final_project/services/helping_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get_it/get_it.dart';

import 'email_login.dart';
import 'email_signup.dart';

class SignUp extends StatelessWidget {
  final auth = GetIt.instance.get<AuthenticationBloc>();
  final String title = LocalizationKeys.signUp;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: Scaffold(
        appBar: AppBar(
          title: Text(this.title).tr(),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "SimpleWeatherApp",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      fontFamily: 'Roboto'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: SignInButton(
                  Buttons.Email,
                  text: LocalizationKeys.singupWithEmail,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EmailSignUp()),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: SignInButton(
                  Buttons.Google,
                  text: LocalizationKeys.singupWithGoogle,
                  onPressed: () async {
                    await auth.signInWithGoogle();
                    if (auth.state.isLogin) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: GestureDetector(
                  child: Text(
                    LocalizationKeys.loginWithEmail,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmailLogIn(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
