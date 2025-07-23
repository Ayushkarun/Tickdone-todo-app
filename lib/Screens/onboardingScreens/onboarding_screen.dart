import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tickdone/Screens/onboardingScreens/onboarding_data.dart';
import 'package:tickdone/Screens/Register/register.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static final PageController _pageController = PageController(initialPage: 0);
  // ignore: prefer_final_fields
  List<Widget> _buildonBoardingpages(BuildContext context) {
    return [
      OnboardingCard(
        image: 'assets/images/onboardimage1.png',
        title: 'Welcome',
        description:
            'TickDone – your smart task manager. Simple, fast, and effective. Tick your tasks, get things done, and boost your day.',
        buttonText: "Next",
        onPressed: () {
          _pageController.animateToPage(
            1,
            duration: Durations.long1,
            curve: Curves.easeInOut,
          );
        },
      ),
      OnboardingCard(
        image: 'assets/images/onboardimage2.png',
        title: 'Stay Organized',
        description:
            'Easily manage your daily tasks. Plan smarter, live better. Achieve more with less stress.',
        buttonText: "Next",
        onPressed: () {
          _pageController.animateToPage(
            2,
            duration: Durations.long1,
            curve: Curves.easeInOut,
          );
        },
      ),
      OnboardingCard(
        image: 'assets/images/onboardimage3.png',
        title: 'Track & Achieve',
        description:
            'Tick tasks as you go and stay focused.Get things done right on time.',
        buttonText: "Get Started",
        onPressed: () {
Navigator.pushReplacement(
  context,
  PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 600), // smooth speed
    pageBuilder: (context, animation, secondaryAnimation) => const Register(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Slide from bottom
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(0.0, 0.3), // Y-axis slide
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut, // smooth feel
      ));

      // Fade in
      final fadeAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeIn,
      );

      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: child,
        ),
      );
    },
  ),
);

        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.05.sh), // 5% of screen height
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: _buildonBoardingpages(context),
              ),
            ),
            SmoothPageIndicator(
              controller: _pageController,
              count: _buildonBoardingpages(context).length,
              onDotClicked: (index) {
                _pageController.animateToPage(
                  index,
                  duration: Durations.long1,
                  curve: Curves.linear,
                );
              },
              effect: ExpandingDotsEffect(
                activeDotColor: Colors.white, // dot for the current page
                dotColor:const Color.fromARGB(255, 255, 255, 255), // dots for the other pages
                dotHeight: 8.w,
                dotWidth: 8.w,
                expansionFactor: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
