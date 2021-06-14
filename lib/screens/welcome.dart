import 'package:flutter/material.dart';
import 'package:investment_portfolio/components/rounded_button.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Keep your investment safe',
              style: TextStyle(fontSize: 21),
            ),
            Text(
              'with us',
              style: TextStyle(fontSize: 21),
            ),
            SizedBox(
              height: 75,
            ),
            Image.asset(
              'assets/img/logo.png',
              width: 200,
              height: 200,
            ),
            SizedBox(
              height: 75,
            ),
            RoundedButton(
              text: 'Get Started',
              minWidth: 125,
              textColor: Colors.white,
              buttonColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
