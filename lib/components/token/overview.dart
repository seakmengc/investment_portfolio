import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:investment_portfolio/components/info_card.dart';
import 'package:investment_portfolio/components/loading.dart';
import 'package:investment_portfolio/helper.dart';
import 'package:investment_portfolio/main.dart';

class TokenOverview extends StatefulWidget {
  final String tokenId;

  const TokenOverview(this.tokenId);

  @override
  _TokenOverviewState createState() => _TokenOverviewState();
}

class _TokenOverviewState extends State<TokenOverview>
    with AutomaticKeepAliveClientMixin {
  getTokenInfo() {
    print(Helper.getTokenInfo(
      widget.tokenId,
    ));
    return Dio()
        .get(Helper.getTokenInfo(
          widget.tokenId,
        ))
        .then((value) => value.data);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            FutureBuilder(
              future: getTokenInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  print(snapshot.hasData);
                  print(snapshot.data);
                  return TokenInfo(
                      (snapshot.data! as List)[0] as Map<String, dynamic>);
                }

                return Loading();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TokenInfo extends StatelessWidget {
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
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
