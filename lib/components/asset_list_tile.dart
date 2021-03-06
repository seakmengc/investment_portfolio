import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:investment_portfolio/components/image_renderer.dart';
import 'package:investment_portfolio/components/token/trending.dart';
import 'package:investment_portfolio/models/asset.dart';
import 'package:investment_portfolio/providers/asset.dart';
import 'package:investment_portfolio/screens/assets/detail.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AssetListTile extends StatelessWidget {
  final Asset asset;
  final AssetStore assetStore;

  const AssetListTile({required this.asset, required this.assetStore});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssetDetailScreen(
              asset: this.asset,
              assetStore: this.assetStore,
            ),
          ),
        );
      },
      leading: ImageRenderer(this.asset.token.logoUrl),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(this.asset.token.id),
          // Text('\$ 60,970.64'),
          Text("Amount: " + this.asset.amount.toString()),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            // '\$ 1,500.89',
            "\$ " +
                new NumberFormat("#,##0.00", "en_US")
                    .format(this.asset.currTotalPrice),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Trending(asset.changes),
        ],
      ),
    );
  }
}
