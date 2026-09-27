import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ride_way_app/features/onboarding/mdodel/onboarding_model.dart';

class OnboardingPageItem extends StatelessWidget {
  final OnboardingModel model;

  const OnboardingPageItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Image.asset(model.imagePath, fit: BoxFit.fill)),
        const SizedBox(height: 64),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            model.titleKey.tr(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            model.descriptionKey.tr(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[400],
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 48),
      ],
    );
  }
}
