import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:investment_portfolio/components/loading.dart';
import 'package:investment_portfolio/models/auth.dart';
import 'package:investment_portfolio/screens/auth/forgot_password.dart';
import 'package:investment_portfolio/screens/dashboard.dart';
import 'package:investment_portfolio/screens/sign_in.dart';
import 'package:investment_portfolio/screens/sign_up.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
      theme: ThemeData(
        primaryColor: Colors.blueGrey.shade900,
        accentColor: const Color(0xff02d39a),
        fontFamily: 'IBMPlex',
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
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
      routes: {
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/signup': (context) => SignUpScreen(),
      },
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
