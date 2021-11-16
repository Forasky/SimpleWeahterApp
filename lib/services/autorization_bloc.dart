import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationBloc extends Cubit<Credits> {
  AuthenticationBloc(Credits initialState) : super(initialState);

  Future signUp(String email, String password, String age, String name) async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      DatabaseReference dbRef =
          FirebaseDatabase.instance.reference().child("Users");
      var result = await firebaseAuth.createUserWithEmailAndPassword(
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
        emit(
          Credits(
            message: 'incorrect user',
            isLogin: false,
          ),
        );
        resetMsg();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(
          Credits(
            message: 'incorrect password',
            isLogin: false,
          ),
        );
        resetMsg();
      } else if (e.code == 'email-already-in-use') {
        emit(
          Credits(
            message: 'account exist',
            isLogin: false,
          ),
        );
        resetMsg();
      }
    } catch (e) {
      emit(
        Credits(
          message: e.toString(),
          isLogin: false,
        ),
      );
      resetMsg();
    }
  }

  Future checkSignIn() async {
    User? result = FirebaseAuth.instance.currentUser;
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
        emit(
          Credits(isLogin: false, message: 'no found'),
        );
        resetMsg();
      } else if (e.code == 'wrong-password') {
        emit(
          Credits(isLogin: false, message: 'incorrect password'),
        );
        resetMsg();
      }
    }
  }

  void resetMsg() {
    Future.delayed(
      const Duration(seconds: 3),
      () => emit(
        Credits(isLogin: false, message: ''),
      ),
    );
  }

  Future logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = FirebaseAuth.instance.currentUser;
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
      emit(
        Credits(isLogin: false, message: ''),
      );
    }
  }
}

class Credits {
  Credits(
      {required this.message, required this.isLogin, this.userName, this.eMail})
      : super();
  String message;
  bool isLogin;
  String? userName;
  String? eMail;
}
