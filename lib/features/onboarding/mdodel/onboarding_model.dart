class OnboardingModel {
  final String imagePath;
  final String titleKey;
  final String descriptionKey;

  const OnboardingModel({
    required this.imagePath,
    required this.titleKey,
    required this.descriptionKey,
  });
}

final List<OnboardingModel> onboardingPages = [
  const OnboardingModel(
    imagePath: 'assets/images/app_images/onboarding1dark.jpg',
    titleKey: 'onboarding.page1_title',
    descriptionKey: 'onboarding.page1_description',
  ),
  const OnboardingModel(
    imagePath: 'assets/images/app_images/onboarding2dark.jpg',
    titleKey: 'onboarding.page2_title',
    descriptionKey: 'onboarding.page2_description',
  ),
  const OnboardingModel(
    imagePath: 'assets/images/app_images/onboarding3dark.jpg',
    titleKey: 'onboarding.page3_title',
    descriptionKey: 'onboarding.page3_description',
  ),
];