// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tickdone/Screens/onboardingScreens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) =>
                  const OnboardingScreen(),
          transitionDuration: const Duration(
            milliseconds: 500,
          ), // Adjust duration as you like
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Use a FadeTransition for a smooth fade-in effect
            return ScaleTransition(scale: animation, child: child);
          },
        ),
      );
    });
  }

  // NEW CODE for initState() in splash_screen.dart

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: 1.sw,
          height: 1.sh,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.45, 0.55],
              colors: [Colors.black, Color(0xFF10083F)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 18.h),
              Image.asset(
                "assets/images/Logo/logofinal.png",
                width: 0.20.sw,
                height: 0.15.sh,
              ),
              Text(
                'TICKDONE',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 27.sp,
                  letterSpacing: 1.w,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                'TICK A TASK, GET IT DONE.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white70,
                  fontSize: 10.sp,
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 23.h),
                child: Column(
                  children: [
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10.sp,
                        color: Colors.white60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ALL RIGHTS RESERVED',
                      style: TextStyle(
                        fontSize: 8.sp,
                        fontFamily: 'Poppins',
                        color: Colors.white60,
                      ),
                    ),
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
