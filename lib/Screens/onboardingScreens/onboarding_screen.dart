import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tickdone/Screens/onboardingScreens/onboarding_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static final PageController _pageController = PageController(initialPage: 0);
  // ignore: prefer_final_fields
  List<Widget> _onBoardingpages = [
    Onboardingcard(
      image: 'assets/images/onboardimage1.png',
      title: 'Welcome',
      description: 'Your smart task manager – tick tasks, get things done.',
      buttonText: "Next",
      onPressed: () {
        _pageController.animateToPage(
          1,
          duration: Durations.long1,
          curve: Curves.linear,
        );
      },
    ),
    Onboardingcard(
      image: 'assets/images/onboardimage2.png',
      title: 'Stay Organized',
      description: 'Easily manage your daily tasks.Plan smarter, live better.',
      buttonText: "Next",
      onPressed: () {
        _pageController.animateToPage(
          2,
          duration: Durations.long1,
          curve: Curves.linear,
        );
      },
    ),
    Onboardingcard(
      image: 'assets/images/onboardimage3.png',
      title: 'Track & Achieve',
      description:
          'Tick tasks as you go and stay focused.Get things done right on time.',
      buttonText: "Get Started",
      onPressed: () {},
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: _onBoardingpages,
              ),
            ),
            SmoothPageIndicator(
              controller: _pageController,
              count: _onBoardingpages.length,
              onDotClicked: (index) {
                _pageController.animateToPage(
                  index,
                  duration: Durations.long1,
                  curve: Curves.linear,
                );
              },
              effect: ExpandingDotsEffect(
                activeDotColor: Colors.white, // dot for the current page
                dotColor: Color(0xFF10083F), // dots for the other pages
                dotHeight: 8,
                dotWidth: 8,
                expansionFactor: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
