import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:investment_portfolio/components/divider_with_text.dart';
import 'package:investment_portfolio/components/icon_rounded_button.dart';
import 'package:investment_portfolio/components/rounded_button.dart';
import 'package:investment_portfolio/constants.dart';
import 'package:investment_portfolio/models/user.dart';
import 'package:investment_portfolio/services/auth.dart';

class SignInScreen extends StatelessWidget {
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
                  hintText: 'Enter your email',
                ),
              ),
              SPACE_BETWEEN_ELEMENT,
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: '********',
                ),
              ),
              SPACE_BETWEEN_ELEMENT,
              RoundedButton(
                text: 'Sign In',
                onPressed: () => {},
              ),
              SPACE_BETWEEN_ELEMENT,
              DividerWithText(text: Text('OR')),
              SPACE_BETWEEN_ELEMENT,
              SignInWithGoogleButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class SignInWithGoogleButton extends StatelessWidget {
  const SignInWithGoogleButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconRoundedButton(
      child: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          CachedNetworkImage(
            imageUrl:
                'https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-suite-everything-you-need-know-about-google-newest-0.png',
            width: 25,
          ),
          SizedBox(
            width: 20,
          ),
          Text('Sign In with Google'),
        ],
      ),
      buttonColor: Colors.white,
      height: 50,
      onPressed: () async {
        final res = await Auth.signInWithGoogle(context: context);

        print(res);
        if (res != null) {
          print(User(email: res.email!, name: res.displayName!));
        }
      },
    );
  }
}
