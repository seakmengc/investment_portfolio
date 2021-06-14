import 'package:flutter/material.dart';

class IconRoundedButton extends StatelessWidget {
  final Widget child;
  final double minWidth;
  final double height;
  final Color buttonColor;

  final void Function()? onPressed;

  IconRoundedButton({
    required this.child,
    this.minWidth = 100,
    this.height = 40,
    this.buttonColor = Colors.blue,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: this.onPressed,
      color: this.buttonColor,
      minWidth: this.minWidth,
      height: this.height,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: this.child,
    );
  }
}
