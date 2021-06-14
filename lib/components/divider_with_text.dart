import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final Text text;
  final Divider? divider;

  const DividerWithText({
    required this.text,
    this.divider,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: this.divider ?? Divider()),
        this.text,
        Expanded(child: this.divider ?? Divider()),
      ],
    );
  }
}
