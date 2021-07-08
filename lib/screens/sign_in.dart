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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 75),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/logo.png',
                width: 150,
                height: 150,
              ),
              SizedBox(height: 75),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'example@gmail.com',
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
              SPACE_BETWEEN_ELEMENT,
              buildInfoText(context),
              SPACE_BETWEEN_ELEMENT,
              SPACE_BETWEEN_ELEMENT,
              SPACE_BETWEEN_ELEMENT,
              DividerWithText(text: Text('Sign in with')),
              SPACE_BETWEEN_ELEMENT,
              SignInWithGoogleButton(),
            ],
          ),
        ),
      ),
    );
  }

  Container buildInfoText(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Text(
        'No account yet? Don\'t worry your input information above will be used to create an account for you.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}

class SignInWithGoogleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconRoundedButton(
      child: Row(
        children: [
          SizedBox(
            width: 30,
          ),
          CachedNetworkImage(
            imageUrl:
                'https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-suite-everything-you-need-know-about-google-newest-0.png',
            width: 25,
          ),
          SizedBox(
            width: 30,
          ),
          Expanded(
            child: Text(
              'Continue with Google',
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
      buttonColor: Colors.white,
      height: 50,
      onPressed: () async {
        final res = await Auth.signInWithGoogle(context: context);

        print(res);
        if (res != null) {
          print(context.read<Auth>().user);
        }
      },
    );
  }
}
