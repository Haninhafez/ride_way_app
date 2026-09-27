import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';

/// A pill-shaped social-auth button with an optional SVG icon.
///
/// Used for Apple and Nafath ID buttons on the Login screen.
class SocialAuthButton extends StatelessWidget {
  const SocialAuthButton({
    super.key,
    required this.label,
    this.svgAsset,
    this.iconData,
    required this.onTap,
  });

  final String label;
  final String? svgAsset;
  final IconData? iconData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: kColorSubtitle,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color.fromARGB(255, 108, 108, 112)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (svgAsset != null)
                SvgPicture.asset(svgAsset!, width: 20, height: 20)
              else if (iconData != null)
                Icon(iconData, size: 20, color: kColorPrimaryAction),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kColorPrimaryAction,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
