import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      // child: CircularProgressIndicator(),
      child: Column(
        children: [
          Image.asset(
            'assets/img/404-error-page.gif',
            width: 100,
          ),
          Text('Not Found'),
        ],
      ),
    );
  }
}
