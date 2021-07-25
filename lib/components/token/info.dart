import 'package:flutter/material.dart';
import 'package:investment_portfolio/components/info_card.dart';
import 'package:investment_portfolio/helper.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoCard(
            header: 'Rank #:',
            text: data['rank'] ?? 'N/A',
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
            header: 'Market Cap:',
            text: Helper.formatNumberToHumanString(data['market_cap'] ?? '0'),
          ),
          InfoCard(
            header: 'Price:',
            text: Helper.moneyFormat(data['price']),
          ),
          InfoCard(
            header: 'ATH:',
            text: Helper.moneyFormat(data['high']),
          ),
          InfoCard(
            header: 'Status:',
            text: data['status'].toString().toUpperCase(),
          ),
        ],
      ),
    );
  }
}
