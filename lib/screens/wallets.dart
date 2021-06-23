import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:investment_portfolio/components/asset_list_tile.dart';
import 'package:investment_portfolio/components/rounded_button.dart';
import 'package:investment_portfolio/models/asset.dart';
import 'package:investment_portfolio/models/auth.dart';
import 'package:investment_portfolio/screens/assets/buy.dart';
import 'package:provider/provider.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  List<Asset> _assets = [];

  @override
  void initState() {
    super.initState();

    fetchAssets(context);
  }

  fetchAssets(BuildContext context) async {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final String userId = context.read<Auth>().user!.id;

    final assets = await firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('assets')
        .get();

    print(assets.docs.first.data());

    assets.docs.forEach((element) {
      this.addAssetCallback(Asset.fromJson(userId, element.data()));
    });

    this._assets.sort(
          (a, b) => b.totalPrice.compareTo(a.totalPrice),
        );

    setState(() {});

    print('1');
  }

  addAssetCallback(Asset addAsset) {
    setState(() {
      try {
        final curr = this
            ._assets
            .firstWhere((element) => element.token.id == addAsset.token.id);

        final totalAmt = curr.amount + addAsset.amount;

        curr.price = (curr.totalPrice + addAsset.totalPrice) / totalAmt;
        curr.amount = totalAmt;
      } catch (ex) {
        this._assets.add(addAsset);
      }
    });
  }

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
}

class MyPortfolios extends StatelessWidget {
  final List<Asset> _assets;

  const MyPortfolios({
    required List<Asset> assets,
  }) : _assets = assets;

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

  const MyBalance({required this.addCallback});

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
          textColor: Colors.grey[700]!,
          onPressed: () => buyButtonOnPressed(context),
        ),
        RoundedButton(
          text: 'Sell',
          minWidth: 175,
          height: 50,
          buttonColor: Colors.red[600]!,
          onPressed: () => buyButtonOnPressed(context),
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
