import 'package:flutter/material.dart';
import 'package:investment_portfolio/screens/buy.dart';
import 'package:investment_portfolio/screens/markets.dart';
import 'package:investment_portfolio/screens/settings.dart';
import 'package:investment_portfolio/screens/sign_in.dart';
import 'package:investment_portfolio/screens/wallets.dart';
import 'package:investment_portfolio/services/auth.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currIndex = 0;

  appBarOnTap(int index) {
    setState(() {
      this._currIndex = index % 3;
      print(index);
      print(index % 3);
    });
  }

  buildPage(int index) {
    if (index == 0) {
      return WalletScreen();
    }

    if (index == 1) {
      return MarketScreen();
    }

    return SettingScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Investment Portfolio',
        // theme: ThemeData.light().copyWith(
        //   // primaryColor: Colors.blueGrey[900],
        //   primaryColor: Colors.white,
        //   accentColor: Colors.blueAccent,
        //   primaryColorDark: Colors.blueGrey[900],
        // ),
        // home: Scaffold(
        //   bottomNavigationBar: buildBottomAppBar(
        //     index: this._currIndex,
        //     onTap: this.appBarOnTap,
        //   ),
        //   body: buildPage(this._currIndex),
        // ),
        home: SignInScreen());
  }

  buildBottomAppBar({required int index, required Function(int) onTap}) {
    return BottomAppBar(
      child: BottomNavigationBar(
        currentIndex: index,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Markets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
