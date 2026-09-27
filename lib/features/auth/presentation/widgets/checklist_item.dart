import 'package:flutter/material.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';

/// A single checklist row showing a validation criterion.
///
/// The icon animates between a grey circle and a green checkmark
/// when [isSatisfied] changes.
class ChecklistItem extends StatelessWidget {
  const ChecklistItem({
    super.key,
    required this.label,
    required this.isSatisfied,
  });

  final String label;
  final bool isSatisfied;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Row(
        key: ValueKey(isSatisfied),
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSatisfied ? kColorSuccess : Colors.transparent,
              border: Border.all(
                color: isSatisfied ? kColorSuccess : kColorSubtitle,
                width: 1.5,
              ),
            ),
            child: isSatisfied
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 11,
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isSatisfied ? kColorSuccess : kColorSubtitle,
              fontWeight:
                  isSatisfied ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
