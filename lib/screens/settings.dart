import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:investment_portfolio/constants.dart';
import 'package:investment_portfolio/models/auth.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SPACE_BETWEEN_ELEMENT,
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider((context
                          .read<Auth>()
                          .user
                          ?.profileUrl !=
                      null
                  ? context.read<Auth>().user?.profileUrl
                  : "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg")!),
              radius: 50.0,
            ),
            SPACE_BETWEEN_ELEMENT,
            Text(
              (context.read<Auth>().isLoggedIn
                  ? context.read<Auth>().user?.name
                  : 'None')!,
              style: TextStyle(
                fontSize: 28,
              ),
            ),
            SPACE_BETWEEN_ELEMENT,
            SPACE_BETWEEN_ELEMENT,
            SPACE_BETWEEN_ELEMENT,
            CardButton(
              icon: Icons.lock_outlined,
              text: 'Change Password',
              onTap: () => context.read<Auth>().logOut(),
            ),
            CardButton(
              icon: Icons.gps_off,
              text: 'Log Out',
              onTap: () => context.read<Auth>().logOut(),
            ),
          ],
        ),
      ),
    );
  }
}

class CardButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function() onTap;

  const CardButton(
      {required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      margin: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 10,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        enableFeedback: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        leading: Icon(this.icon),
        title: Text(this.text),
        onTap: this.onTap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
