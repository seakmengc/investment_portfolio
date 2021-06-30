import 'package:flutter/material.dart';
import 'package:investment_portfolio/screens/markets.dart';
import 'package:investment_portfolio/screens/settings.dart';
import 'package:investment_portfolio/screens/wallets.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int _currIndex = 2;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController =
        TabController(initialIndex: _currIndex, length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();

    super.dispose();
  }

  appBarOnTap(int index) {
    setState(() {
      this._currIndex = index % 3;
      tabController.index = this._currIndex;
      // print(index);
      // print(index % 3);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomAppBar(
        index: this._currIndex,
        onTap: appBarOnTap,
      ),
      body: TabBarView(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          WalletScreen(),
          MarketScreen(),
          SettingScreen(),
        ],
      ),
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
