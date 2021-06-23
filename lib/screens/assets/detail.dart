import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:investment_portfolio/constants.dart';
import 'package:investment_portfolio/models/asset.dart';

class AssetDetailScreen extends StatelessWidget {
  final Asset asset;

  const AssetDetailScreen({required this.asset});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          headerSliverBuilder: buildSliverAppBar,
          body: TabBarView(
            children: [
              OverviewTab(),
              TransactionHistoryTab(),
            ],
          ),
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
              Tab(icon: Icon(Icons.dashboard)),
              Tab(icon: Icon(Icons.sync)),
            ],
          ),
        ),
        pinned: true,
      ),
    ];
  }
}

class OverviewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Overview'),
    );
  }
}

class TransactionHistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('TransactionHistoryTab'),
    );
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
