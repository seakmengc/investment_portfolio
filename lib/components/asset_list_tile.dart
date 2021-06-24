import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:investment_portfolio/models/asset.dart';
import 'package:investment_portfolio/screens/assets/detail.dart';
import 'package:intl/intl.dart';

class AssetListTile extends StatelessWidget {
  final Asset asset;

  const AssetListTile({required this.asset});

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
            ),
          ),
        );
      },
      leading: this.asset.token.hasSvgLogo
          ? SvgPicture.network(
              this.asset.token.logoUrl,
              width: 30,
            )
          : Image.network(
              this.asset.token.logoUrl,
              width: 30,
            ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(this.asset.token.id),
          // Text('\$ 60,970.64'),
          Text(this.asset.amount.toString()),
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
                    .format(this.asset.totalPrice),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '4.28%',
                style: TextStyle(
                  color: Colors.greenAccent,
                ),
              ),
              Icon(
                Icons.north_east,
                size: 15,
                color: Colors.greenAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
