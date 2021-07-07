import 'package:flutter/material.dart';
import 'package:investment_portfolio/components/animated_text.dart';
import 'package:investment_portfolio/constants.dart';

class Trending extends StatelessWidget {
  late final double percentages;

  Trending(double percentages) {
    this.percentages = percentages * 100.0;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          !percentages.isNegative ? Icons.trending_up : Icons.trending_down,
          color: !percentages.isNegative ? Colors.green : Colors.red,
        ),
        WIDTH_BETWEEN_ELEMENT,
        AnimatedText(
          text: percentages.toStringAsFixed(2) + '%',
          style: TextStyle(
            color: !percentages.isNegative ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}
