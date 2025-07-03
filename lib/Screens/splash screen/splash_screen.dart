// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:tickdone/Screens/onboardingScreens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

//splash screen
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      //intro screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }
///screenutil
  @override
  Widget build(BuildContext context) {
    //media query for icon
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          //for 2 color
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              //screen size
              stops: [0.4, 0.6],
              colors: [Colors.black, Color(0xFF10083F)],
            ),
          ),
          child: Column(
            ///center
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              SizedBox(height: 18),
              Image.asset(
                "assets/images/logo.png",
                width: screenwidth * 0.2,
                height: screenheight * 0.15,
              ),

              Text(
                'TICKDONE',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: screenwidth * 0.075,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'TICK A TASK, GET IT DONE.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: screenwidth * 0.026,
                ),
              ),
              //for space
              Spacer(),

              Padding(
                padding: EdgeInsets.only(bottom: 23.0),
                child: Column(
                  children: [
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontSize: screenwidth * 0.028,
                        color: Colors.white60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ALL RIGHTS RESERVED',
                      style: TextStyle(
                        fontSize: screenwidth * 0.022,
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
