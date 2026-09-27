import 'package:flutter/material.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';

/// Primary full-width pill action button in charcoal black.
///
/// Used as the main CTA on all three auth screens ("Sign in",
/// "Create account", "Update password").
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: kColorPrimaryAction,
            gradient: LinearGradient(
              colors: [Colors.black87, Colors.black38, Colors.black],
              tileMode: TileMode.decal,
              begin: Alignment.topRight,
              end: AlignmentGeometry.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          alignment: Alignment.center,
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: KColorDarkGold,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
        ),
      ),
    );
  }
}
