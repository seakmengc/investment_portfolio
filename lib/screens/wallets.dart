import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:investment_portfolio/components/wallet/my_balance.dart';
import 'package:investment_portfolio/components/wallet/my_portfolio.dart';
import 'package:investment_portfolio/helper.dart';
import 'package:investment_portfolio/models/asset.dart';
import 'package:investment_portfolio/models/auth.dart';
import 'package:investment_portfolio/models/transac.dart';
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

    // print(assets.docs.first.data());

    assets.docs.forEach((element) {
      print(Asset.fromJson(userId, element.data()).token.logoUrl);

      this._assets.add(Asset.fromJson(userId, element.data()));
    });

    this._assets.sort(
          (a, b) => b.totalPrice.compareTo(a.totalPrice),
        );

    setState(() {});

    getLatestData();

    print('fetched assets from firestore.');
  }

  addAssetCallback(Asset addAsset) async {
    Asset curr;
    bool newly = false;
    setState(() {
      try {
        curr = this
            ._assets
            .firstWhere((element) => element.token.id == addAsset.token.id);

        final totalAmt = curr.amount + addAsset.amount;

        curr.price = (curr.totalPrice + addAsset.totalPrice) / totalAmt;
        curr.amount = totalAmt;
      } catch (ex) {
        curr = addAsset;
        newly = true;
      }

      final transac = Transac(
        asset: curr,
        price: curr.price,
        amount: curr.amount,
        type: "buy",
      );

      curr.addTransaction(transac);

      transac.persist();

      curr.persist();

      if (newly) {
        this._assets.add(curr);
      }
    });
  }

  sellAssetCallback(Transac transac) {
    final curr =
        this._assets.firstWhere((element) => element.id == transac.asset.id);

    transac.persist();
    curr.addTransaction(transac);

    setState(() {});
  }

  getLatestData() {
    final ids = this._assets.map((e) => e.id).toList();
    print(Helper.getTokensInfo(ids));

    print(ids);
    if (ids.isEmpty) {
      return;
    }

    return Dio().get(Helper.getTokensInfo(ids)).then((value) {
      final data = value.data as List;

      data.forEach((element) {
        try {
          final asset = this
              ._assets
              .firstWhere((asset) => asset.token.id == element['id']);

          asset.currPrice = double.parse(element['price']);
        } catch (err) {
          // print("Not found " + element['id']);
        }
      });

      setState(() {});
      print(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          MyBalance(
            addCallback: addAssetCallback,
            sellCallback: sellAssetCallback,
            assets: _assets,
          ),
          MyPortfolios(assets: _assets),
        ],
      ),
    );
  }
}
