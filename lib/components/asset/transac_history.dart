import 'package:flutter/material.dart';
import 'package:investment_portfolio/components/asset/transac_list_tile.dart';
import 'package:investment_portfolio/components/loading.dart';
import 'package:investment_portfolio/models/asset.dart';
import 'package:investment_portfolio/models/transac.dart';

class TransacHistory extends StatefulWidget {
  final Asset asset;

  const TransacHistory(this.asset);

  @override
  _TransacHistoryState createState() => _TransacHistoryState();
}

class _TransacHistoryState extends State<TransacHistory>
    with AutomaticKeepAliveClientMixin {
  final List<Transac> transacs = [];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder(
      future: Transac.getByAsset(widget.asset),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView(
            children:
                (snapshot.data as List).map((e) => TransacListTile(e)).toList(),
          );
        }

        return Loading();
      },
    );
  }
}
