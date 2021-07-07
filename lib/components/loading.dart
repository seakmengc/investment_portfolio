import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      // child: CircularProgressIndicator(),
      child: Image.asset(
        'assets/img/loading.gif',
        width: 100,
      ),
    );
  }
}
