import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:investment_portfolio/helper.dart';
import 'package:investment_portfolio/components/rounded_button.dart';
import 'package:investment_portfolio/constants.dart';
import 'package:investment_portfolio/models/auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = new TextEditingController();

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
              SPACE_F2_BETWEEN_ELEMENT,
              RoundedButton(
                text: 'Send Email',
                minWidth: double.infinity,
                height: 50,
                onPressed: () async {
                  try {
                    final res = await Auth.sendResetEmail(
                      emailController.text,
                    );

                    print(res);
                    if (res != null) {
                      throw Exception();
                    }

                    Helper.showSnackBar(
                      context: context,
                      type: SnackBarType.SUCCESS,
                      text: "Forgot password email has been sent to you.",
                    );

                    Navigator.pop(context);
                  } on FirebaseAuthException catch (error) {
                    print(error.message);
                    Helper.showSnackBar(
                      context: context,
                      type: SnackBarType.ERROR,
                      text: error.message,
                    );
                  } catch (error) {
                    Helper.showSnackBar(
                      context: context,
                      type: SnackBarType.ERROR,
                      text: 'Something went wrong.',
                    );
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
