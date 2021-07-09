import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:investment_portfolio/components/animated_text.dart';
import 'package:investment_portfolio/components/rounded_button.dart';
import 'package:investment_portfolio/components/token/trending.dart';
import 'package:investment_portfolio/constants.dart';
import 'package:investment_portfolio/models/asset.dart';
import 'package:investment_portfolio/models/transac.dart';
import 'package:investment_portfolio/screens/assets/buy.dart';
import 'package:investment_portfolio/screens/assets/sell.dart';

class MyBalance extends StatelessWidget {
  final Function(Asset) addCallback;
  final Function(Transac) sellCallback;
  final List<Asset> assets;
  final List<Asset> assets;

  MyBalance({
    required this.addCallback,
    required this.sellCallback,
    required this.assets,
  });

  calTotalBalance() {
    double sum = 0;
    this.assets.forEach((element) {
      sum += element.currTotalPrice;
    });

    return sum;
  }

  @override
  Widget build(BuildContext context) {
    double totalBalance = calTotalBalance();

    return Container(
      padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
      width: double.infinity,
      // color: Colors.blueGrey.shade900,
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
          AnimatedText(
            text: '\$ ' +
                new NumberFormat("#,##0.00", "en_US").format(totalBalance),
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
      children: [
        Expanded(
          child: RoundedButton(
            text: 'Buy',
            minWidth: 175,
            height: 50,
            buttonColor: Colors.white,
            textColor: Colors.grey[700]!,
            onPressed: () async {
              await buyButtonOnPressed(context);
              calTotalBalance();
            },
          ),
        ),
        WIDTH_BETWEEN_ELEMENT,
        WIDTH_BETWEEN_ELEMENT,
        Expanded(
          child: RoundedButton(
            text: 'Sell',
            minWidth: 175,
            height: 50,
            buttonColor: Colors.red[600]!,
            onPressed: () async {
              await sellButtonOnPressed(context);
              calTotalBalance();
            },
          ),
        ),
      ],
    );
  }

  Row buildDailyPL() {
    double current = 0.0;
    double bought = 0.0;
    this.assets.forEach((element) {
      current += element.currTotalPrice;
      bought += element.totalPrice;
    });

    final double changes = (current - bought) / bought;
    return Row(
      children: [
        AnimatedText(
          text: "\$ " +
              new NumberFormat("#,##0.00", "en_US").format(current - bought),
          style: TextStyle(
            fontSize: 18,
            color: changes.isNegative ? Colors.red : Colors.green,
          ),
        ),
        SizedBox(width: 25),
        Trending(changes),
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
