import 'package:final_project/models/autorization_model.dart';
import 'package:final_project/services/helping_classes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationBloc extends Cubit<Credits> {
  AuthenticationBloc(Credits initialState) : super(initialState);

  Future signUp(String email, String password, String age, String name) async {
    try {
      final firebaseAuth = FirebaseAuth.instance;
      final dbRef = FirebaseDatabase.instance.reference().child("Users");
      final result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (FirebaseAuth.instance.currentUser != null) {
        dbRef.child(result.user!.uid).set(
          {"email": email, "age": age, "name": name},
        );
        emit(
          Credits(
            message: '',
            isLogin: true,
            userName: name,
            eMail: email,
          ),
        );
      } else {
        setFalse('incorrect user');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setFalse(
          LocalizationKeys.incorrectPassword,
        );
      } else if (e.code == 'email-already-in-use') {
        setFalse(
          LocalizationKeys.accountExist,
        );
      }
    } catch (e) {
      setFalse(
        e.toString(),
      );
    }
  }

  Future checkSignIn() async {
    final result = FirebaseAuth.instance.currentUser;
    if (result != null)
      emit(
        Credits(
          message: '',
          isLogin: true,
          eMail: result.email,
          userName: result.displayName,
        ),
      );
  }

  Future signIn(String email, String password) async {
    try {
      var result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (result.user?.uid != null) {
        emit(
          Credits(
            isLogin: true,
            message: '',
            eMail: result.user?.email,
            userName: result.user?.displayName,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setFalse(
          LocalizationKeys.userNoFound,
        );
      } else if (e.code == 'wrong-password') {
        setFalse(
          LocalizationKeys.incorrectPassword,
        );
      }
    }
  }

  Future logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        emit(
          Credits(
            isLogin: true,
            message: '',
            eMail: user.email,
            userName: user.displayName,
          ),
        );
      }
    } on FirebaseAuthException catch (_) {
      setFalse(
        LocalizationKeys.userNoFound,
      );
    }
  }

  void setFalse(String message) {
    emit(
      Credits(
        message: message,
        isLogin: false,
      ),
    );
    Future.delayed(
      const Duration(seconds: 3),
      () => emit(
        Credits(
          isLogin: false,
          message: '',
        ),
      ),
    );
  }

  String validation(String text, String type) {
    switch (type) {
      case 'email':
        {
          if (text.isEmpty) {
            return LocalizationKeys.enterEmail;
          } else if (!text.contains('@')) {
            return LocalizationKeys.plsEnterEmail;
          }
          return '';
        }
      case 'password':
        {
          if (text.isEmpty) {
            return LocalizationKeys.enterPassword;
          } else if (text.length < 6) {
            return LocalizationKeys.plsEnterPassword;
          }
          return '';
        }
      case 'name':
        {
          if (text.isEmpty) {
            return LocalizationKeys.enterName;
          }
          return '';
        }
      case 'age':
        {
          if (text.isEmpty) {
            return LocalizationKeys.enterAge;
          }
          return '';
        }
    }
    return '';
  }
}
