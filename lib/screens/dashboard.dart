import 'package:flutter/material.dart';
import 'package:investment_portfolio/screens/markets.dart';
import 'package:investment_portfolio/screens/settings.dart';
import 'package:investment_portfolio/screens/wallets.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currIndex = 1;

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
    return Scaffold(
      bottomNavigationBar: buildBottomAppBar(
        index: this._currIndex,
        onTap: appBarOnTap,
      ),
      body: buildPage(this._currIndex),
    );
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
