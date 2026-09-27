import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_way_app/core/database/cache/cache_helper.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';
import 'package:ride_way_app/features/onboarding/mdodel/onboarding_model.dart';
import 'package:ride_way_app/features/onboarding/widgets/onboarding_page_item.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<Widget> pages = [
    OnboardingPageItem(model: onboardingPages[0]),
    OnboardingPageItem(model: onboardingPages[1]),
    OnboardingPageItem(model: onboardingPages[2]),
  ];

  int currentPage = 0;
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBackgroundnew,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          children: [
            // Top Navigation Row
            Row(
              children: [
                // Back Arrow: Shows ONLY when currentPage > 0
                if (currentPage > 0)
                  GestureDetector(
                    onTap: () => _controller.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),

                const Spacer(),

                // Skip Button
                GestureDetector(
                  onTap: ()async{
                       await CacheHelper.saveData(
                        key: 'isOnboardingSeen',
                        value: true,
                      );

                      if (mounted) {
                        context.go('/login');
                      }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: kColorSubtitleold.withAlpha(40),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: Text(
                      'skip'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => currentPage = index),
                itemBuilder: (context, index) {
                  return pages[index];
                },
              ),
            ),

            // Bottom Indicators and Next Button
            Row(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: pages.length,
                  effect: ExpandingDotsEffect(
                    expansionFactor: 5,
                    dotHeight: 10,
                    dotWidth: 8,
                    activeDotColor: kColorAccentGold,
                    dotColor: Colors.white.withAlpha(80),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    if (currentPage == pages.length - 1) {
                      print('onboarding finish');

                      await CacheHelper.saveData(
                        key: 'isOnboardingSeen',
                        value: true,
                      );

                      if (mounted) {
                        context.go('/login');
                      }

                      print('onboarding done');
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: kColorAccentGold,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'next'.tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: kColorBackgroundnew,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          color: kColorBackgroundnew,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
