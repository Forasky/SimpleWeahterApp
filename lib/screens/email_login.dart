// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:final_project/bloc/autorization_bloc.dart';
import 'package:final_project/models/autorization_model.dart';
import 'package:final_project/screens/main_screen.dart';
import 'package:final_project/services/helping_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class EmailLogIn extends StatefulWidget {
  @override
  _EmailLogInState createState() => _EmailLogInState();
}

class _EmailLogInState extends State<EmailLogIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final bloc = GetIt.instance.get<AuthenticationBloc>();

  final isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationBlocState>(
      bloc: bloc,
      builder: (context, state) {
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: Scaffold(
            appBar: AppBar(
              title: Text(
                LocalizationKeys.login,
              ),
            ),
            body: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: LocalizationKeys.enterEmail,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) => bloc.validation(
                          value ?? '',
                          'email',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: LocalizationKeys.enterPassword,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) => bloc.validation(
                          value ?? '',
                          'password',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: isLoading
                          ? CircularProgressIndicator()
                          : Row(
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.lightBlue),
                                  ),
                                  onPressed: () {
                                    bloc.signIn(
                                      emailController.text,
                                      passwordController.text,
                                    );
                                    if (state.isLogin)
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MainScreen(),
                                        ),
                                      );
                                    else {
                                      AlertDialog(
                                        title: Text(
                                          LocalizationKeys.error,
                                        ),
                                        content:
                                            Text(state.message.toString().tr()),
                                        actions: [
                                          ElevatedButton(
                                            child: Text(
                                              LocalizationKeys.submit,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    }
                                  },
                                  child: Text(
                                    LocalizationKeys.submit,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  state.message,
                                ),
                              ],
                            ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
