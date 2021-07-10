import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:investment_portfolio/models/token.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:investment_portfolio/models/user.dart' as Model;

class Auth extends ChangeNotifier {
  bool _loggedIn = false;
  Model.User? user;

  bool get isLoggedIn => this._loggedIn;

  Model.User? get getAuth => this.user;

  void loggedIn(Model.User user) {
    this._loggedIn = true;
    this.user = user;
    print('loggedIn');
    print(this._loggedIn);

    notifyListeners();
  }

  changePassword(String newPassword) async {
    print("Change password");
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    User? currentUser = firebaseAuth.currentUser;
    if (currentUser != null) {
      await currentUser.updatePassword(newPassword);
    }
  }

  logOut() async {
    this._loggedIn = false;
    this.user = null;
    await FirebaseAuth.instance.signOut();

    notifyListeners();
  }

  static Future<FirebaseApp> initializeFirebase(BuildContext context) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    print("Done initialize firebase");
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      print("in");
      print(user);
      print(Model.User.fromFirebaseAuthUser(user));
      context.read<Auth>().loggedIn(Model.User.fromFirebaseAuthUser(user));
    }
    Token.saveToFirestore();
    print("Done try login");

    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential? userCredential;

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
        userCredential = await auth.signInWithCredential(credential);
      } catch (ex) {
        print(ex);
        // handle the error here
      }
    }

    if (userCredential != null) {
      Auth.afterAuthenticatedFromFirebase(context, userCredential);
    }

    return userCredential?.user;
  }

  static Future<User?> signInWithEmailPassword({
    required BuildContext context,
    required email,
    required password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential? userCredential;

    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      if (ex.code != 'user-not-found') {
        throw ex;
      }
      print(ex.code);
      print(ex.runtimeType);

      // create not existing user
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    }

    Auth.afterAuthenticatedFromFirebase(context, userCredential);

    return userCredential.user;
  }

  static void afterAuthenticatedFromFirebase(
      BuildContext context, UserCredential userCredential) async {
    final User user = userCredential.user!;

    Model.User? auth = await Model.User.findById(user.uid);

    if (auth == null) {
      auth = Model.User.fromFirebaseAuthUser(user);

      auth.persist();
    }

    context.read<Auth>().loggedIn(auth);
  }

  static sendResetEmail(String email) {
    FirebaseAuth auth = FirebaseAuth.instance;

    return auth.sendPasswordResetEmail(email: email);
  }
}
