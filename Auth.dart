import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
// sign up with email and password
  Future<UserCredential?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential user =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      return user;
    } on FirebaseAuthException catch (e) 
      if (e.code == 'network-request-failed') {
        MyWidgets.showSnackbar(msg: "No Internet Connection", context: context);
      }
      if (e.code == 'email-already-in-use') {
        MyWidgets.showSnackbar(
            msg: "Account Exists Already!! Please Login", context: context);
      }
      if (e.code == 'invalid-email') {
        MyWidgets.showSnackbar(msg: "Invalid Email Address", context: context);
      }
      if (e.code == 'weak-password') {
        MyWidgets.showSnackbar(msg: "Weak Password", context: context);
      }
    }
  }
  // google sign in
  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      try {
        UserCredential firebaseUser =
            await FirebaseAuth.instance.signInWithCredential(credential);

      
        return firebaseUser;
      } catch (e) {
        print(e);
      }
    }
    return null;
  }


//sign in with email and password

  Future<UserCredential?>({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential user =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "wrong-password":
          MyWidgets.showSnackbar(
              msg: "Incorrect Password / Email", context: context);
          break;
        case "user-not-found":
          MyWidgets.showSnackbar(
              msg: "Account Does not Exists", context: context);
          break;
      }
    }
  }
// Sign out method
  Future<true> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
     
    } catch (e) {
      // print(e.toString());
return false;
    }
  }
}