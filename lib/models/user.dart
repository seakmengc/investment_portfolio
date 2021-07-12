import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;

class User {
  String id;
  late String email = '';
  late String name;
  late DateTime createdAt;
  String? profileUrl;

  User({
    required this.id,
    required String? email,
    name = '',
    this.profileUrl,
  }) {
    this.email = email == null ? 'dummy@gmail.com' : email;

    this.name = name == '' ? this.email.split("@").first : name;

    this.createdAt = DateTime.now();
  }

  factory User.fromFirebaseAuthUser(FirebaseAuth.User firebaseUser) {
    return new User(
      id: firebaseUser.uid,
      email: firebaseUser.email,
      name: firebaseUser.displayName ?? '',
      profileUrl: firebaseUser.photoURL,
    );
  }

  factory User.fromFirebaseAuthUserWithName(
      FirebaseAuth.User firebaseUser, String name) {
    return new User(
      id: firebaseUser.uid,
      email: firebaseUser.email,
      name: name,
      profileUrl: firebaseUser.photoURL,
    );
  }

  void persist() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference userCollection = firestore.collection('users');

    await userCollection.doc(this.id).set(this.toJson());
  }

  static Future<User?> findById(String id) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final userDoc = await firestore
        .collection('users')
        .limit(1)
        .where('id', isEqualTo: id)
        .get();

    User? user;
    if (userDoc.docs.isNotEmpty) {
      final data = userDoc.docs.first.data();

      user = new User(
        id: data['id'],
        email: data['email'],
        name: data['name'],
        profileUrl: data['profileUrl'] ?? null,
      );
    }

    return user;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'email': this.email,
      'name': this.name,
      'profileUrl': this.profileUrl,
      'createdAt': this.createdAt.toIso8601String()
    };
  }
}
