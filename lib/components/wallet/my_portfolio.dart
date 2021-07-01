import 'package:flutter/material.dart';
import 'package:investment_portfolio/components/asset_list_tile.dart';
import 'package:investment_portfolio/models/asset.dart';

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
          child: ListView(
            padding: EdgeInsets.zero,
            children: this._assets.map((e) => AssetListTile(asset: e)).toList(),
          ),
        ),
      ],
    );
  }
}
