import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nazra/peresentation/onBoarding/widgets/build_page.dart';
import 'package:nazra/peresentation/resources/color_manager.dart';
import 'package:nazra/peresentation/resources/font_manager.dart';
import 'package:nazra/peresentation/resources/styles_manager.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../app/providers/theme_provider.dart';
import '../../routing/routes.dart';
import '../widgets/app_text_btn.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      // No bottomSheet anymore
      body: Container(
        // full-screen gradient (same as before)
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: themeProvider.isDarkMode
                ? [
              Theme.of(context).colorScheme.surface, // beige
                  Theme.of(context).colorScheme.secondary, // lighter brown
              Theme.of(context).colorScheme.surface, // beige

            ]
                : [
              Theme.of(context).colorScheme.surface, // beige
              Theme.of(context).colorScheme.background, // white
              Theme.of(context).colorScheme.surface, // beige

            ],

          ),
        ),
        // build layout with PageView + bottom controls inside the same container
        child: SafeArea(
          child: Column(
            children: [
              // PageView takes remaining space above controls
              Expanded(
                child: PageView(
                  controller: controller,
                  onPageChanged: (index) {
                    setState(() => isLastPage = index == 2);
                  },
                  children: const [
                    BuildPage(
                      imageHeight: 351,
                      imageWidth: double.maxFinite,
                      imagePath: 'assets/images/onboarding1.png',
                      title: "See, Snap, Improve",
                      subtitle:
                      "With every glance, our streets get better. Report an issue and see it fixed",
                    ),
                    BuildPage(
                      imageHeight: 340,
                      imageWidth: 350,
                      imagePath: "assets/images/onboarding2.png",
                      title: "Report in Seconds",
                      subtitle:
                      "It’s faster than you think. Snap a photo, add the location, and send your report in under 30 seconds.",
                    ),
                    BuildPage(
                      imageWidth: 360,
                      imageHeight: 340,
                      imagePath: "assets/images/onboarding3.png",
                      title: "Follow the Progress",
                      subtitle:
                      "Stay updated every step of the way. From new report to solved — see how Nazra turns issues into improvements.",
                    ),
                  ],
                ),
              ),

              // Bottom controls (indicator + buttons)
              Container(
                height: 200.h,
                padding: const EdgeInsets.all(10),
                // no color -> transparent so gradient shows through
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: ScaleEffect(
                        activeDotColor: Theme.of(context).primaryColor,
                        activeStrokeWidth: 0.1,
                        dotWidth: 7,
                        dotHeight: 7,
                        scale: 1.7,
                        dotColor: ColorManager.lightBrown,
                        spacing: 15,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    if (isLastPage) ...[
                      AppTextBtn(
                        buttonHeight: 56.h,
                        buttonWidth: 300.w,
                        buttonText: "Login",
                        textStyle: regularStyle(
                          fontSize: FontSize.s18,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pushNamed(
                          context,
                          Routes.loginRoute,
                        ),
                        borderRadius: 10,
                      ),
                      SizedBox(height: 20.h),
                      AppTextBtn(
                        buttonHeight: 56.h,
                        buttonWidth: 300.w,
                        buttonText: "Sign up",
                        textStyle: regularStyle(
                          fontSize: FontSize.s18,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        onPressed: () {
                          if (themeProvider.isDarkMode) {
                            themeProvider.setTheme(ThemeMode.light);
                          } else {
                            themeProvider.setTheme(ThemeMode.dark);
                          }
                        },
                        backGroundColor: Colors.transparent,
                        borderRadius: 10,
                      ),
                    ] else ...[
                      AppTextBtn(
                        buttonHeight: 56.h,
                        buttonWidth: 300.w,
                        buttonText: "Next",
                        onPressed: () => controller.nextPage(
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 300),
                        ),
                        textStyle: regularStyle(
                          fontSize: FontSize.s18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      AppTextBtn(
                        buttonHeight: 56.h,
                        buttonWidth: 300.w,
                        buttonText: "Skip",
                        textStyle: regularStyle(
                          fontSize: FontSize.s18,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        backGroundColor: Colors.transparent,

                        onPressed: () => controller.jumpToPage(2),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
