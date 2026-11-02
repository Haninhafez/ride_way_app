import 'package:flutter/material.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/custom_text_field.dart';

class PasswordFeild extends StatefulWidget {
  const PasswordFeild({
    super.key,
    this.validator,
    this.onChanged,
  });

  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  @override
  State<PasswordFeild> createState() => _PasswordFeildState();
}

class _PasswordFeildState extends State<PasswordFeild> {
  final bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return PasswordTextField(
      hint: '••••••••',
      validator: widget.validator,
      onChanged: widget.onChanged != null
          ? (v) => widget.onChanged!(v)
          : null,
    );
  }
}
