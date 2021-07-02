import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:investment_portfolio/components/loading.dart';
import 'package:investment_portfolio/models/auth.dart';
import 'package:investment_portfolio/screens/dashboard.dart';
import 'package:investment_portfolio/screens/sign_in.dart';
import 'package:provider/provider.dart';

void main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider<Auth>(create: (_) => Auth()),
    ], child: MyApp()),
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
      theme: ThemeData.light().copyWith(
        // primaryColor: Colors.deepOrange[700],
        // primaryColor: Color(0xff23b6e6),
        primaryColor: Colors.blueGrey.shade900,
        accentColor: const Color(0xff02d39a),
      ),
      themeMode: ThemeMode.dark,
      home: FutureBuilder(
        future: Auth.initializeFirebase(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print(context.watch<Auth>().isLoggedIn);
            return AuthScreen();
          }

          return Loading();
        },
      ),
    );
  }
}

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Auth:");
    print(context.watch<Auth>().isLoggedIn);
    return context.watch<Auth>().isLoggedIn
        ? DashboardScreen()
        : SignInScreen();
  }
}
