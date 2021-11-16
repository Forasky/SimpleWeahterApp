// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:final_project/screens/main_screen.dart';
import 'package:final_project/services/autorization_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class EmailLogIn extends StatefulWidget {
  @override
  _EmailLogInState createState() => _EmailLogInState();
}

class _EmailLogInState extends State<EmailLogIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final bloc = GetIt.instance.get<AuthenticationBloc>();

  bool isLoading = false;

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
            appBar: AppBar(title: Text("login").tr()),
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
                          labelText: "enter Email".tr(),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enter Email'.tr();
                          } else if (!value.contains('@')) {
                            return 'please enter Email'.tr();
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: "enter password".tr(),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enter password'.tr();
                          } else if (value.length < 6) {
                            return 'please enter password'.tr();
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: isLoading
                          ? CircularProgressIndicator()
                          : Row(
                              children: [
                                Text(state.message),
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
                                        title: Text("error").tr(),
                                        content: Text(state.message.toString()),
                                        actions: [
                                          ElevatedButton(
                                            child: Text("submit").tr(),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    }
                                  },
                                  child: Text('submit').tr(),
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
