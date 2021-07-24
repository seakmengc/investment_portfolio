import 'package:flutter/material.dart';
import 'package:investment_portfolio/components/asset_list_tile.dart';
import 'package:investment_portfolio/components/errors/not_found.dart';
import 'package:investment_portfolio/constants.dart';
import 'package:investment_portfolio/providers/asset.dart';
import 'package:provider/provider.dart';

class MyPortfolios extends StatefulWidget {
  @override
  _MyPortfoliosState createState() => _MyPortfoliosState();
}

class _MyPortfoliosState extends State<MyPortfolios> {
  late AssetStore assetStore;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    assetStore = context.watch<AssetStore>();
    return Container(
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      margin: EdgeInsets.only(top: 270),
      height: MediaQuery.of(context).size.height * 0.8,
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
          child: this.assetStore.assets.isEmpty
              ? buildPorfolioNotFound()
              : buildPortfolio(),
        ),
      ],
    );
  }

  ListView buildPortfolio() {
    return ListView(
      padding: EdgeInsets.zero,
      children: this
          .assetStore
          .assets
          .map((e) => AssetListTile(asset: e, assetStore: assetStore))
          .toList(),
    );
  }

  Center buildPorfolioNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NotFound(),
          SPACE_BETWEEN_ELEMENT,
          Text(
            'Please add an asset first.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
