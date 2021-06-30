import 'package:flutter/material.dart';
import 'package:investment_portfolio/components/rounded_button.dart';
import 'package:investment_portfolio/models/auth.dart';
import 'package:provider/provider.dart';

class ChangePasswordDialog extends StatefulWidget {
  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final passwordControlller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Password'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: '********',
              ),
              controller: passwordControlller,
            ),
          ],
        ),
      ),
      actions: [
        RoundedButton(
          text: 'Update',
          onPressed: () async {
            await context.read<Auth>().changePassword(passwordControlller.text);

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
