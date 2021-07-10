import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:investment_portfolio/components/animated_text.dart';
import 'package:investment_portfolio/components/rounded_button.dart';
import 'package:investment_portfolio/components/token/trending.dart';
import 'package:investment_portfolio/constants.dart';
import 'package:investment_portfolio/models/asset.dart';
import 'package:investment_portfolio/models/transac.dart';
import 'package:investment_portfolio/providers/asset.dart';
import 'package:investment_portfolio/screens/assets/buy.dart';
import 'package:investment_portfolio/screens/assets/sell.dart';
import 'package:provider/provider.dart';

class MyBalance extends StatelessWidget {
  calTotalBalance(List<Asset> assets) {
    double sum = 0;
    assets.forEach((element) {
      sum += element.currTotalPrice;
    });

    return sum;
  }

  @override
  Widget build(BuildContext context) {
    final AssetStore assetStore = context.watch<AssetStore>();
    double totalBalance = calTotalBalance(assetStore.assets);

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
          buildDailyPL(assetStore.assets),
          SizedBox(height: 15),
          buildRowButtons(context)
        ],
      ),
    );
  }

  Row buildRowButtons(BuildContext context) {
    final AssetStore assetStore = context.read<AssetStore>();

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
              await buyButtonOnPressed(context, assetStore.addAssetCallback);
              calTotalBalance(assetStore.assets);
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
              await sellButtonOnPressed(
                  context, assetStore.sellAssetCallback, assetStore.assets);
              calTotalBalance(assetStore.assets);
            },
          ),
        ),
      ],
    );
  }

  Row buildDailyPL(List<Asset> assets) {
    double current = 0.0;
    double bought = 0.0;
    assets.forEach((element) {
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

  buyButtonOnPressed(context, void Function(Asset) callback) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BuyScreeen(),
      ),
    );

    print(result);

    if (result != null) {
      callback(result);
    }
  }

  sellButtonOnPressed(BuildContext context, void Function(Transac) callback,
      List<Asset> assets) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SellScreen(assets: assets),
      ),
    );

    print(result);

    if (result != null) {
      callback(result);
    }
  }
}
