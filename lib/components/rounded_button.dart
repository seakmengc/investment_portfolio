import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final double minWidth;
  final double height;
  final Color textColor;
  final Color? buttonColor;

  final void Function()? onPressed;

  RoundedButton({
    this.text = '',
    this.minWidth = 100,
    this.height = 40,
    this.textColor = Colors.white,
    this.buttonColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: this.onPressed,
      color: this.buttonColor ?? Theme.of(context).primaryColor,
      textColor: this.textColor,
      minWidth: this.minWidth,
      height: this.height,
      disabledColor: (this.buttonColor ?? Theme.of(context).primaryColor)
          .withOpacity(0.75),
      disabledTextColor: this.textColor.withOpacity(0.5),
      disabledElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: Text(this.text),
    );
  }
}
