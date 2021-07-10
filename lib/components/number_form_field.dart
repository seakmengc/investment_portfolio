import 'package:flutter/material.dart';

class NumberFormField extends StatelessWidget {
  final label;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;

  const NumberFormField(
      {this.label, this.controller, this.validator, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      focusNode: focusNode,
      keyboardType: TextInputType.numberWithOptions(
        decimal: true,
      ),
      validator: this.validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: this.label,
      ),
    );
  }
}
