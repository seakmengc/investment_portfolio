import 'package:flutter/material.dart';
import 'package:investment_portfolio/models/auth.dart';
import 'package:investment_portfolio/screens/dashboard.dart';
import 'package:investment_portfolio/screens/sign_in.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (_) => Auth()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Investment Portfolio',
      home:
          context.watch<Auth>().isLoggedIn ? DashboardScreen() : SignInScreen(),
    );
  }
}
