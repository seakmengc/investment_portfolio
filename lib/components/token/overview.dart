import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:investment_portfolio/components/info_card.dart';
import 'package:investment_portfolio/helper.dart';

class TokenOverview extends StatefulWidget {
  final String tokenId;

  const TokenOverview(this.tokenId);

  @override
  _TokenOverviewState createState() => _TokenOverviewState();
}

class _TokenOverviewState extends State<TokenOverview> {
  getTokenInfo() {
    print(Helper.getTokenInfo(widget.tokenId));
    return Dio()
        .get(Helper.getTokenInfo(widget.tokenId))
        .then((value) => value.data);
  }

  @override
  Widget build(BuildContext context) {
    print(
      Helper.getSparkLineInfo(
        widget.tokenId,
        DateTime.now().subtract(Duration(days: 1)),
      ),
    );
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(widget.tokenId),
          // InfoCard(),
          // InfoCard(),
          FutureBuilder(
            future: getTokenInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                print(snapshot.hasData);
                print(snapshot.data);
                return TokenInfo(
                    (snapshot.data! as List)[0] as Map<String, dynamic>);
              }

              return Center(
                child: Text('Loading'),
              );
            },
          ),
        ],
      ),
    );
  }
}

class TokenInfo extends StatelessWidget {
  final Map<String, dynamic> data;

  final List<String> keys = [
    'id',
    'currency',
    'name',
    'price',
    'market_cap',
    'rank',
    'high',
  ];

  TokenInfo(this.data);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: keys
          .map((String e) => InfoCard(
              header: e.replaceAll('_', ' ').toUpperCase() + ':',
              text: data[e].toString()))
          .toList(),
    );
  }
}
