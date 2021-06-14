import 'package:flutter/material.dart';
import 'package:investment_portfolio/components/asset_list_tile.dart';
import 'package:investment_portfolio/components/rounded_button.dart';
import 'package:investment_portfolio/constants.dart';
import 'package:investment_portfolio/models/asset.dart';
import 'package:investment_portfolio/models/token.dart';
import 'package:investment_portfolio/screens/buy.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  List<Asset> _assets = [
    Asset(
      token: Token(id: 'ADA', symbol: 'ADA', logoUrl: ADA_URL),
      price: 1.0,
      amount: 3,
    ),
    Asset(
      token: Token(id: 'ETH', symbol: 'ETH', logoUrl: ETH_URL),
      price: 2000,
      amount: 5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          MyBalance(
            addCallback: addAssetCallback,
          ),
          MyPortfolios(assets: _assets),
        ],
      ),
    );
  }

  addAssetCallback(Asset addAsset) {
    setState(() {
      final curr = this
          ._assets
          .firstWhere((element) => element.token.id == addAsset.token.id);

      if (curr == null) {
        this._assets.add(addAsset);
      } else {
        final totalAmt = curr.amount + addAsset.amount;

        curr.price = (curr.totalPrice + addAsset.totalPrice) / totalAmt;
        curr.amount = totalAmt;
      }
    });
  }
}

class MyPortfolios extends StatelessWidget {
  const MyPortfolios({
    required List<Asset> assets,
  }) : _assets = assets;

  final List<Asset> _assets;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      margin: EdgeInsets.only(top: 270),
      height: 400,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        padding: EdgeInsets.only(top: 15),
        child: buildBody(),
      ),
    );
  }

  Column buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            'My Portfolios',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: this._assets.map((e) => AssetListTile(asset: e)).toList(),
          ),
        ),
      ],
    );
  }
}

class MyBalance extends StatelessWidget {
  final Function(Asset) addCallback;

  const MyBalance({Key? key, required this.addCallback}) : super(key: key);

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
            '\$ 2,445.21',
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
          onPressed: () => buyButtonOnPressed(context),
        ),
        RoundedButton(
          text: 'Sell',
          minWidth: 175,
          height: 50,
          buttonColor: Colors.grey[700]!,
          textColor: Colors.white,
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
}
