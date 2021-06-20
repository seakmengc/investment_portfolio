import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:investment_portfolio/models/user.dart' as Model;

class Auth extends ChangeNotifier {
  bool _loggedIn = false;
  Model.User? user;

  bool get isLoggedIn => this._loggedIn;

  void loggedIn(Model.User user) {
    this._loggedIn = true;
    this.user = user;

    notifyListeners();
  }

  void logOut() {
    this._loggedIn = false;
    this.user = null;

    notifyListeners();
  }

  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    // TODO: Add auto login logic

    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    await Auth.initializeFirebase();

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } catch (ex) {
        print(ex);
        // handle the error here
      }
    }

    if (user != null && user.email != null) {
      context.read<Auth>().loggedIn(
            new Model.User(
              email: user.email!,
              name: user.displayName!,
            ),
          );
    }

    return user;
  }

  static Future<User?> signInWithEmailPassword({
    required BuildContext context,
    required email,
    required password,
  }) async {
    await Auth.initializeFirebase();

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      final UserCredential userCredential = await auth
          .signInWithEmailAndPassword(email: email, password: password);
      print(userCredential);
      user = userCredential.user;
    } on FirebaseAuthException catch (ex) {
      if (ex.code != 'user-not-found') {
        throw ex;
      }
      print(ex.code);
      print(ex.runtimeType);

      // create not existing user
      final UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);

      user = userCredential.user;
    }

    if (user != null && user.email != null) {
      context.read<Auth>().loggedIn(
            new Model.User(
              email: user.email,
              profileUrl: user.photoURL,
            ),
          );
    }

    return user;
  }
}
