import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.theme,
    required this.svgPicture,
    required this.ButtonText,
  });

  final ThemeData theme;
  final svgPicture;
  final String ButtonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        spacing: 10,
        children: [
          SvgPicture.asset(height: 30, svgPicture),
          Text(ButtonText, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
