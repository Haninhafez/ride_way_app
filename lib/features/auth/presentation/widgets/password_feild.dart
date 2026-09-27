// password_feild.dart — Legacy stub kept for backward compatibility.
// The new [PasswordTextField] in custom_text_field.dart supersedes this widget.
// No active screens reference this file; it is retained to avoid orphan errors.
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
  bool _obscure = true;

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
