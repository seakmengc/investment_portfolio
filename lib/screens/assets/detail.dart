import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:investment_portfolio/components/asset/transac_history.dart';
import 'package:investment_portfolio/components/image_renderer.dart';
import 'package:investment_portfolio/components/token/overview.dart';
import 'package:investment_portfolio/models/asset.dart';
import 'package:investment_portfolio/providers/asset.dart';
import 'package:investment_portfolio/screens/assets/buy.dart';
import 'package:investment_portfolio/screens/assets/sell.dart';
import 'package:provider/provider.dart';

class AssetDetailScreen extends StatelessWidget {
  final Asset asset;
  final AssetStore assetStore;

  const AssetDetailScreen({required this.asset, required this.assetStore});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Row(
            children: [
              ImageRenderer(asset.token.logoUrl),
              SizedBox(width: 7),
              Text(asset.token.id),
            ],
          ),
          bottom: TabBar(
            labelColor: Colors.black87,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.sync,
                  color: Colors.white,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.dashboard,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TransacHistory(asset),
            TokenOverview(asset.token.id),
          ],
        ),
        floatingActionButton: SpeedDial(
          backgroundColor: Theme.of(context).primaryColor,
          icon: Icons.menu,
          activeIcon: Icons.close,
          renderOverlay: false,
          iconTheme: IconThemeData(color: Colors.white),
          children: [
            SpeedDialChild(
              child: Icon(Icons.remove),
              backgroundColor: Colors.red,
              label: 'Sell',
              onTap: () async {
                final transac = await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SellScreen(
                      assetId: asset.id,
                      assets: assetStore.assets,
                    ),
                  ),
                );

                print(transac);
                if (transac == null) {
                  return;
                }

                this.assetStore.sellAssetCallback(transac);
                Navigator.of(context).pop();
              },
              onLongPress: () => print('FIRST CHILD LONG PRESS'),
            ),
            SpeedDialChild(
              child: Icon(Icons.add),
              backgroundColor: Colors.blue,
              label: 'Buy',
              onTap: () async {
                final addedAsset = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BuyScreeen(tokenId: asset.token.id),
                  ),
                );

                print(addedAsset);

                if (addedAsset == null) {
                  return;
                }

                this.assetStore.addAssetCallback(addedAsset);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildSliverAppBar(context, innerBoxIsScrolled) {
    return [
      SliverAppBar(
        expandedHeight: 250,
        floating: true,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          title: Text(this.asset.token.id),
          background: Padding(
            padding: const EdgeInsets.all(35),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(this.asset.token.logoUrl),
                  fit: BoxFit.fitHeight,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  decoration:
                      BoxDecoration(color: Colors.white.withOpacity(0.0)),
                ),
              ),
            ),
          ),
        ),
      ),
      SliverPersistentHeader(
        delegate: _SliverAppBarDelegate(
          TabBar(
            labelColor: Colors.black87,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.sync)),
              Tab(icon: Icon(Icons.dashboard)),
            ],
          ),
        ),
        pinned: true,
      ),
    ];
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
