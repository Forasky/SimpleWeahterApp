// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:final_project/bloc/autorization_bloc.dart';
import 'package:final_project/models/autorization_model.dart';
import 'package:final_project/services/helping_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'main_screen.dart';

class EmailSignUp extends StatefulWidget {
  @override
  _EmailSignUpState createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  final bloc = GetIt.instance.get<AuthenticationBloc>();
  final isLoading = false;
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final ageController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, Credits>(
      bloc: bloc,
      builder: (context, state) {
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: Scaffold(
            appBar: AppBar(
              title: Text(
                LocalizationKeys.signUp,
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
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: LocalizationKeys.enterName,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) => bloc.validation(
                          value ?? '',
                          'name',
                        ),
                      ),
                    ),
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
                        controller: ageController,
                        decoration: InputDecoration(
                          labelText: LocalizationKeys.enterAge,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) => bloc.validation(
                          value ?? '',
                          'age',
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
                                    bloc.signUp(
                                      emailController.text,
                                      passwordController.text,
                                      ageController.text,
                                      nameController.text,
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
                                        content: Text(
                                          state.message,
                                        ),
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
                    ),
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
