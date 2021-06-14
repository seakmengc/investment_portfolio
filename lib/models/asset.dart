import 'package:investment_portfolio/models/token.dart';

class Asset {
  final Token token;
  double price;
  double amount;

  Asset({required this.token, required this.price, required this.amount});

  double get totalPrice {
    return this.price * this.amount;
  }
}
