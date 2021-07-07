import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:investment_portfolio/components/divider_with_text.dart';
import 'package:investment_portfolio/components/icon_rounded_button.dart';
import 'package:investment_portfolio/components/rounded_button.dart';
import 'package:investment_portfolio/constants.dart';
import 'package:investment_portfolio/models/user.dart';
import 'package:investment_portfolio/models/auth.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 75),
              Image.asset(
                'assets/img/logo.png',
                width: 200,
                height: 200,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'khmer@gmail.com',
                ),
                controller: emailController,
              ),
              SPACE_BETWEEN_ELEMENT,
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: '********',
                ),
                controller: passwordController,
              ),
              SPACE_BETWEEN_ELEMENT,
              SPACE_BETWEEN_ELEMENT,
              RoundedButton(
                text: 'Sign In',
                minWidth: double.infinity,
                height: 50,
                onPressed: () async {
                  final res = await Auth.signInWithEmailPassword(
                    context: context,
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  print(res);
                  if (res != null) {
                    print(context.read<Auth>().user);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
