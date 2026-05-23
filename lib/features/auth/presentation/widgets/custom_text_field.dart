import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
   CustomTextField({
    super.key,
    required this.theme,
    required this.hint,
  
    this.validator,
    this.onChanged,
    this.obscureText = false, this.controller,
  });

  final ThemeData theme;
  final String hint;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final bool obscureText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:controller ,
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hint: Text(hint, style: TextStyle(color: Colors.grey.shade500)),
      ),
    );
  }
}
