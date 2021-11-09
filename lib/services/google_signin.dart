import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationBloc extends Bloc {
  late GoogleSignInAccount user;
  
  AuthenticationBloc(initialState) : super(initialState);
  GoogleSignInAccount get use => user;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return Text('some error with this');
    user = googleUser;
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);
    await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
