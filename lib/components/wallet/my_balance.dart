import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:investment_portfolio/components/rounded_button.dart';
import 'package:investment_portfolio/models/asset.dart';
import 'package:investment_portfolio/models/transac.dart';
import 'package:investment_portfolio/screens/assets/buy.dart';
import 'package:investment_portfolio/screens/assets/sell.dart';

class MyBalance extends StatelessWidget {
  final Function(Asset) addCallback;
  final Function(Transac) sellCallback;
  final List<Asset> assets;
  late final double totalBalance;

  MyBalance({
    required this.addCallback,
    required this.sellCallback,
    required this.assets,
  }) {
    this.totalBalance = calTotalBalance();
  }

  calTotalBalance() {
    double sum = 0;
    this.assets.forEach((element) {
      sum += element.totalPrice;
    });

    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      height: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 15),
          Text(
            '\$ ' + new NumberFormat("#,##0.00", "en_US").format(totalBalance),
            style: TextStyle(
              fontSize: 45,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 15),
          buildDailyPL(),
          SizedBox(height: 15),
          buildRowButtons(context)
        ],
      ),
    );
  }

  Row buildRowButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RoundedButton(
          text: 'Buy',
          minWidth: 175,
          height: 50,
          buttonColor: Colors.white,
          textColor: Colors.grey[700]!,
          onPressed: () {
            buyButtonOnPressed(context);
            calTotalBalance();
          },
        ),
        RoundedButton(
          text: 'Sell',
          minWidth: 175,
          height: 50,
          buttonColor: Colors.red[600]!,
          onPressed: () {
            sellButtonOnPressed(context);
            calTotalBalance();
          },
        ),
      ],
    );
  }

  Row buildDailyPL() {
    return Row(
      children: [
        Text(
          '+ \$ 252.26',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 25),
        Text(
          '4.28%',
          style: TextStyle(
            fontSize: 18,
            color: Colors.greenAccent,
          ),
        ),
        Icon(
          Icons.trending_up,
          color: Colors.greenAccent,
        ),
      ],
    );
  }

  buyButtonOnPressed(context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BuyScreeen(),
      ),
    );

    print(result);

    if (result != null) {
      this.addCallback(result);
    }
  }

  sellButtonOnPressed(context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SellScreen(assets: assets),
      ),
    );

    print(result);

    if (result != null) {
      this.sellCallback(result);
    }
  }
}
