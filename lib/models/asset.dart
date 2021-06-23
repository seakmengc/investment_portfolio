import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:investment_portfolio/models/token.dart';

class Asset extends ChangeNotifier {
  final String userId;
  final Token token;
  double price;
  double amount;

  late DateTime boughtAt;

  Asset({
    required this.userId,
    required this.token,
    required this.price,
    required this.amount,
    DateTime? boughtAt,
  }) {
    this.boughtAt = boughtAt ?? DateTime.now();

    getTokenUrl();
  }

  double get totalPrice {
    return this.price * this.amount;
  }

  void getTokenUrl() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final docSnapshots =
        await firestore.collection("tokens").doc(this.token.id).get();

    final doc = docSnapshots.data();
    print("Token from firestore");
    print(doc);
    if (doc != null) {
      this.token.logoUrl = doc['logoUrl'] ?? '';
    }

    notifyListeners();
  }

  persist() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore
        .collection("users")
        .doc(this.userId)
        .collection('assets')
        .add(this.toJson());
  }

  Map<String, dynamic> toJson() {
    return {
      'tokenId': this.token.id,
      'price': this.price,
      'amount': this.amount,
      'boughtAt': FieldValue.serverTimestamp()
    };
  }

  factory Asset.fromJson(String userId, Map<String, dynamic> json) {
    print(json);
    return new Asset(
      userId: userId,
      token: new Token(id: json['tokenId']),
      price: json['price'],
      amount: json['amount'],
      boughtAt:
          DateTime.tryParse(json['boughtAt'].toString()) ?? DateTime.now(),
    );
  }
}
