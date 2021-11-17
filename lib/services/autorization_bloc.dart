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
        setFalse('incorrect user');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setFalse('incorrect password');
      } else if (e.code == 'email-already-in-use') {
        setFalse('account exist');
      }
    } catch (e) {
      setFalse(
        e.toString(),
      );
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
        setFalse('no found');
      } else if (e.code == 'wrong-password') {
        setFalse('incorrect password');
      }
    }
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
      setFalse('no found');
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
        Credits(isLogin: false, message: ''),
      ),
    );
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
