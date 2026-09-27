import 'package:flutter/material.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';

enum PasswordStrength { none, weak, medium, strong }

/// 3-segment animated password strength bar with a label.
///
/// Segments light up progressively: red → amber → green.
/// The [strength] value drives animation via [AnimatedContainer].
class PasswordStrengthBar extends StatelessWidget {
  const PasswordStrengthBar({
    super.key,
    required this.strength,
    this.weakLabel = 'Weak',
    this.mediumLabel = 'Medium',
    this.strongLabel = 'Strong',
  });

  final PasswordStrength strength;
  final String weakLabel;
  final String mediumLabel;
  final String strongLabel;

  Color _segmentColor(int segmentIndex) {
    switch (strength) {
      case PasswordStrength.weak:
        return segmentIndex == 0 ? const Color(0xFFFF3B30) : kColorBorder;
      case PasswordStrength.medium:
        return segmentIndex <= 1 ? const Color(0xFFFF9500) : kColorBorder;
      case PasswordStrength.strong:
        return kColorSuccess;
      case PasswordStrength.none:
        return kColorBorder;
    }
  }

  String get _label {
    switch (strength) {
      case PasswordStrength.weak:
        return weakLabel;
      case PasswordStrength.medium:
        return mediumLabel;
      case PasswordStrength.strong:
        return strongLabel;
      case PasswordStrength.none:
        return '';
    }
  }

  Color get _labelColor {
    switch (strength) {
      case PasswordStrength.weak:
        return const Color(0xFFFF3B30);
      case PasswordStrength.medium:
        return const Color(0xFFFF9500);
      case PasswordStrength.strong:
        return kColorSuccess;
      case PasswordStrength.none:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(3, (i) {
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: 4,
                margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                decoration: BoxDecoration(
                  color: _segmentColor(i),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        if (strength != PasswordStrength.none) ...[
          const SizedBox(height: 6),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _labelColor,
            ),
            child: Text(_label),
          ),
        ],
      ],
    );
  }
}
