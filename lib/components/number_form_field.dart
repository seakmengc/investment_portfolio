import 'package:flutter/material.dart';

class NumberFormField extends StatelessWidget {
  final label;
  final TextEditingController? controller;

  const NumberFormField({this.label, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      keyboardType: TextInputType.numberWithOptions(
        decimal: true,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: this.label,
      ),
    );
  }
}
