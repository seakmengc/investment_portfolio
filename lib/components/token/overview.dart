import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:investment_portfolio/components/info_card.dart';
import 'package:investment_portfolio/components/loading.dart';
import 'package:investment_portfolio/constants.dart';
import 'package:investment_portfolio/helper.dart';

import "dart:math";

class TokenOverview extends StatefulWidget {
  final String tokenId;

  const TokenOverview(this.tokenId);

  @override
  _TokenOverviewState createState() => _TokenOverviewState();
}

class _TokenOverviewState extends State<TokenOverview>
    with AutomaticKeepAliveClientMixin {
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  getTokenInfo() {
    print(Helper.getTokenInfo(
      widget.tokenId,
    ));

    return Helper.retryHttp(Helper.getTokenInfo(
      widget.tokenId,
    ));
  }

  getTokenSparklineInfo() {
    print(Helper.getSparkLineInfo(
        widget.tokenId, DateTime.now().subtract(Duration(days: 1))));

    return Helper.retryHttp(Helper.getSparkLineInfo(
      widget.tokenId,
      DateTime.now().subtract(Duration(days: 1)),
    ));
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
            Container(
              height: 300,
              child: FutureBuilder(
                future: getTokenSparklineInfo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    print(snapshot.hasData);
                    final data = (snapshot.data as List<dynamic>)[0]
                        as Map<String, dynamic>;

                    print(data);

                    return CustomLineChart(
                      data: data,
                      gradientColors: gradientColors,
                    );
                  }

                  return Loading();
                },
              ),
            ),
            FutureBuilder(
              future: getTokenInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  print(snapshot.hasData);
                  print(snapshot.data);
                  return TokenInfo(
                    (snapshot.data! as List)[0] as Map<String, dynamic>,
                  );
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

class CustomLineChart extends StatelessWidget {
  final Map<String, dynamic> data;
  final List<Color> gradientColors;

  late final List<double> prices;
  late final List<FlSpot> spots;

  CustomLineChart({
    required this.data,
    required this.gradientColors,
  }) {
    final _prices = List<double>.from(
      data['prices'].map((price) => double.parse(price)),
    );

    int reduceBy = 3;
    prices = [];
    spots = [];

    for (var i = 0; i < _prices.length; i += reduceBy) {
      prices.add(_prices[i]);
      spots.add(FlSpot(
        i.toDouble(),
        _prices[i].toDouble(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Build custom line chart");

    return Container(
      height: 300,
      padding: const EdgeInsets.only(right: 20.0),
      child: LineChart(
        LineChartData(
          minX: 0,
          // maxX: prices.reduce(max) / 2 * 1.1,
          //price
          minY: prices.reduce(min) * 0.95,
          maxY: prices.reduce(max) * 1.05,
          gridData: FlGridData(
            show: true,
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: false,
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) => const TextStyle(
                color: Color(0xff67727d),
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
              rotateAngle: -30,
              getTitles: (value) {
                return Helper.formatNumberToHumanString(value, 2);
              },
              reservedSize: 35,
              margin: 7,
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              colors: gradientColors,
              barWidth: 5,
              // dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                colors: gradientColors
                    .map((color) => color.withOpacity(0.3))
                    .toList(),
              ),
            )
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

  TokenInfo(this.data);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview:',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          InfoCard(
            header: 'Rank #:',
            text: data['rank'],
          ),
          InfoCard(
            header: 'Name:',
            text: data['name'],
          ),
          InfoCard(
            header: 'Currency:',
            text: data['currency'],
          ),
          InfoCard(
            header: 'Market cap:',
            text: Helper.formatNumberToHumanString(data['market_cap']),
          ),
          InfoCard(
            header: 'Price:',
            text: Helper.moneyFormat(data['price']),
          ),
          InfoCard(
            header: 'ATH:',
            text: Helper.moneyFormat(data['high']),
          ),
        ],
      ),
    );
  }
}
