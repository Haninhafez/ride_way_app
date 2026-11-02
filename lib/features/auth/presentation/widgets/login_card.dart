import 'package:flutter/material.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({
    super.key,
    required this.width,
    required this.formKey,
  });

  final double width;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
