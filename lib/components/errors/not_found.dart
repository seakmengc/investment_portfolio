import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      // child: CircularProgressIndicator(),
      child: Column(
        children: [
          Lottie.asset(
            'assets/animations/404-error-page.json',
            width: 100,
          ),
          Text('Not Found'),
        ],
      ),
    );
  }
}
