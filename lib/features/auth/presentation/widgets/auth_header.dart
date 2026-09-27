import 'package:flutter/material.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';

/// App logo header displayed at the top of each auth screen.
///
/// Shows the RideWay train icon badge + brand name "RideWay".
/// Optionally shows a back button via [showBackButton].
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, this.showBackButton = false, this.onBack});

  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showBackButton)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: GestureDetector(
              onTap: onBack,
              child: Container(
                width: 40,
                height: 40,

                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: kColorPrimaryAction,
                ),
              ),
            ),
          ),
        const SizedBox(width: 24),
        // Logo badge
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: kColorPrimaryAction,
            borderRadius: BorderRadius.circular(15),
            border: BoxBorder.all(color: KColorDarkGold, width: 2),
          ),

          child: Image.asset(
            'assets/images/icon_images/icon_app.png',
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        // Brand name
        const Text(
          'RideWay',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w800,
            color: kColorBorder,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
