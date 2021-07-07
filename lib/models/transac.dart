import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:investment_portfolio/models/asset.dart';

class Transac {
  final Asset asset;
  double price;
  double amount;
  final String type;

  late DateTime transacAt;

  Transac({
    required this.asset,
    required this.price,
    required this.amount,
    required this.type,
    DateTime? transacAt,
  }) {
    this.transacAt = transacAt ?? DateTime.now();
  }

  double get totalPrice {
    return this.price * this.amount;
  }

  bool get isBought => this.type == "buy";

  persist() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore
        .collection('users')
        .doc(this.asset.userId)
        .collection('assets')
        .doc(this.asset.id)
        .collection("transactions")
        .add(this.toJson());
  }

  Map<String, dynamic> toJson() {
    return {
      'price': this.price,
      'amount': this.amount,
      'type': this.type,
      'transacAt': FieldValue.serverTimestamp(),
    };
  }

  factory Transac.fromJson(Asset asset, Map<String, dynamic> json) {
    // print(json['transacAt']);
    return new Transac(
      asset: asset,
      type: json['type'],
      price: json['price'],
      amount: json['amount'],
      transacAt: json['transacAt'] != null
          ? (json['transacAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  static Future<List<Transac>> getByAsset(Asset asset) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final transCollection = await firestore
        .collection('users')
        .doc(asset.userId)
        .collection('assets')
        .doc(asset.id)
        .collection("transactions")
        .orderBy('transacAt', descending: true)
        .get();

    return transCollection.docs
        .map((e) => Transac.fromJson(asset, e.data()))
        .toList();
  }
}
