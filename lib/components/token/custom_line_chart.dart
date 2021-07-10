import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:investment_portfolio/components/errors/not_found.dart';
import 'package:investment_portfolio/components/loading.dart';
import "dart:math";

import 'package:investment_portfolio/helper.dart';

class CustomLineChart extends StatefulWidget {
  final String tokenId;

  CustomLineChart({
    required this.tokenId,
  });

  @override
  _CustomLineChartState createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  int chartDays = 1;

  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  final List<int> days = [1, 7, 30, 60, 365];

  getTokenSparklineInfo() {
    print(Helper.getSparkLineInfo(
      widget.tokenId,
      DateTime.now().subtract(Duration(days: chartDays)),
      end: DateTime.now(),
    ));

    return Helper.retryHttp(Helper.getSparkLineInfo(
      widget.tokenId,
      DateTime.now().subtract(Duration(days: chartDays)),
      end: DateTime.now(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    print("Build custom line chart");

    return Column(
      children: [
        buildHeader(),
        FutureBuilder(
          future: getTokenSparklineInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              print(snapshot.hasData);
              if (!snapshot.hasData ||
                  (snapshot.data as List<dynamic>).isEmpty) {
                return NotFound();
              }

              final data =
                  (snapshot.data as List<dynamic>)[0] as Map<String, dynamic>;

              print(data);

              final _prices = List<double>.from(
                data['prices'].map((price) => double.parse(price)),
              );

              final List<double> prices = [];
              final List<FlSpot> spots = [];

              int reduceBy = _prices.length ~/ 7.0;
              for (var i = 0; i < _prices.length; i += reduceBy) {
                prices.add(_prices[i]);
                spots.add(FlSpot(
                  i.toDouble(),
                  _prices[i].toDouble(),
                ));
              }

              print("LENGTH: " + prices.length.toString());

              return Card(
                elevation: 7,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                child: buildBody(
                    prices, List<String>.from(data['timestamps']), spots),
              );
            }

            return Loading();
          },
        ),
      ],
    );
  }

  Row buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Chart:',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButton(
          elevation: 7,
          value: chartDays,
          onChanged: (index) {
            if (int.parse(index.toString()) == chartDays) {
              return;
            }

            setState(() {
              chartDays = int.parse(index.toString());
            });
          },
          items: days
              .map((int e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.toString() + 'D'),
                  ))
              .toList(),
        ),
      ],
    );
  }

  buildBody(List<double> prices, List<String> timestamps, List<FlSpot> spots) {
    return Container(
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
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
          titlesData: buildTitleData(prices, timestamps),
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

  FlTitlesData buildTitleData(List<double> prices, List<String> timestamps) {
    final textStyle = const TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );

    final diff = (prices.reduce(max) * 1.05) - (prices.reduce(min) * 0.95);
    final leftInterval = diff / (prices.length > 7 ? 7 : prices.length);

    print("INT: " + diff.toString());
    print("LEN: " + prices.length.toString());

    return FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        getTitles: (value) {
          return DateFormat(chartDays >= 7 ? "dd-MM" : "kk:mm").format(
            DateTime.parse(timestamps[value.toInt()].toString()).toLocal(),
          );
        },
        getTextStyles: (value) => textStyle,
        interval: timestamps.length / 7.0,
        reservedSize: 25,
        margin: 10,
        rotateAngle: -30,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        interval: diff < 0.01 ? diff / 6.0 : leftInterval,
        getTextStyles: (value) => textStyle,
        rotateAngle: -30,
        getTitles: (value) {
          return Helper.formatNumberToHumanString(value, 2);
        },
        reservedSize: 25,
        margin: 10,
      ),
    );
  }
}
