import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:investment_portfolio/components/wallet/my_balance.dart';
import 'package:investment_portfolio/components/wallet/my_portfolio.dart';
import 'package:investment_portfolio/helper.dart';
import 'package:investment_portfolio/models/asset.dart';
import 'package:investment_portfolio/providers/asset.dart';
import 'package:investment_portfolio/models/auth.dart';
import 'package:provider/provider.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with AutomaticKeepAliveClientMixin {
  List<Asset> _assets = [];

  final AssetStore assetStore = new AssetStore();

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

    final List<Asset> assetsToAdd = [];

    assets.docs.forEach((element) {
      print(Asset.fromJson(userId, element.data()).token.logoUrl);

      assetsToAdd.add(Asset.fromJson(userId, element.data()));
    });

    assetStore.addAssets(assetsToAdd);

    getLatestData();

    print('fetched assets from firestore.');
  }

  getLatestData() {
    final ids = assetStore.assets.map((e) => e.id).toList();
    print(Helper.getTokensInfo(ids));

    print(ids);
    if (ids.isEmpty) {
      return;
    }

    return Helper.retryHttp(Helper.getTokensInfo(ids)).then((data) {
      data.forEach((element) {
        try {
          final asset = assetStore.assets
              .firstWhere((asset) => asset.token.id == element['id']);

          asset.currPrice = double.parse(element['price']);
        } catch (err) {
          // print("Not found " + element['id']);
        }
      });

      assetStore.sortAssets();
      assetStore.notify();

      print(data);
    });
  }

  @override
  void didUpdateWidget(covariant WalletScreen oldWidget) {
    getLatestData();

    super.didUpdateWidget(oldWidget);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListenableProvider<AssetStore>(
      create: (ctx) => assetStore,
      child: Container(
        child: Stack(
          children: [
            MyBalance(),
            MyPortfolios(),
          ],
        ),
      ),
    );
  }
}
