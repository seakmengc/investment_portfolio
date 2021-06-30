import 'package:flutter/material.dart';

class AnimatedText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const AnimatedText({required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: Text(
        this.text,
        key: ValueKey<String>(this.text),
        style: this.style,
      ),
    );
  }
}
