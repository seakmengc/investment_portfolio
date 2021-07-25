import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:investment_portfolio/components/custom_future_builder.dart';
import 'package:investment_portfolio/components/loading.dart';
import 'package:investment_portfolio/models/auth.dart';
import 'package:investment_portfolio/screens/auth/forgot_password.dart';
import 'package:investment_portfolio/screens/dashboard.dart';
import 'package:investment_portfolio/screens/sign_in.dart';
import 'package:investment_portfolio/screens/sign_up.dart';
import 'package:investment_portfolio/screens/welcome.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Widget buildScreen(BuildContext context, AsyncSnapshot snapshot) {
    final prefs = snapshot.data as SharedPreferences;
    final newUserKey = 'new-user';
    // prefs.clear();

    if (prefs.containsKey(newUserKey)) {
      return AuthScreen();
    }

    prefs.setBool(newUserKey, true);

    return WelcomeScreen();
  }

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
      home: CustomFutureBuilder(
        futureFn: () => Auth.initializeFirebase(context),
        successWidget: (_, __) => CustomFutureBuilder(
          futureFn: SharedPreferences.getInstance,
          successWidget: buildScreen,
        ),
      ),
      routes: {
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/signup': (context) => SignUpScreen(),
        '/signin': (context) => SignInScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/auth': (context) => AuthScreen(),
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
