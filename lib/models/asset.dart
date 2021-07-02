import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:investment_portfolio/models/token.dart';
import 'package:investment_portfolio/models/transac.dart';

class Asset extends ChangeNotifier {
  late final String id;
  final String userId;
  final Token token;
  double price;
  double amount;
  late double currPrice;

  Asset({
    required this.userId,
    required this.token,
    required this.price,
    required this.amount,
  }) {
    this.id = this.token.id;

    this.currPrice = this.price;

    // getTokenUrl();
  }

  double get totalPrice {
    return this.price * this.amount;
  }

  double get currTotalPrice {
    return this.currPrice * this.amount;
  }

  double get changes {
    return (this.currPrice - this.price) / 100.0;
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

  addTransaction(Transac transac) {
    if (transac.type == "buy") {
      this.amount += transac.amount;

      this.price = (transac.totalPrice + this.totalPrice) / this.amount;
    } else {
      if (this.amount - transac.amount < 0) {
        throw new Exception("Exceed max amount.");
      }

      double amount = this.amount - transac.amount;

      this.price = (this.totalPrice - transac.totalPrice) / amount;
      this.amount = amount;
    }

    this.persist();
  }

  persist() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore
        .collection("users")
        .doc(this.userId)
        .collection('assets')
        .doc(this.id)
        .set(this.toJson());
  }

  Map<String, dynamic> toJson() {
    return {
      'token': this.token.toJson(),
      'price': this.price,
      'amount': this.amount
    };
  }

  factory Asset.fromJson(String userId, Map<String, dynamic> json) {
    print(json);
    return new Asset(
      userId: userId,
      token: Token.fromJson(json['token']),
      price: json['price'],
      amount: json['amount'],
    );
  }
}
