// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tickdone/Services/Provider/user_provider.dart';
import 'package:tickdone/Views/OnboardingScreens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tickdone/Services/Api/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:tickdone/Views/Authentication/Login/login.dart';
import 'package:tickdone/Views/Home/bottomnav.dart';
import 'package:tickdone/Services/Provider/user_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeUserandNavigate();
    // checkSessionAndNavigate();
  }

  Future<void> _initializeUserandNavigate() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // Load username saved locally (SharedPreferences)
    await userProvider.loadUserNamefromPrefs();

    //Get auth
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userUID');
    final idToken = prefs.getString('idToken');
    // If uid and idToken exist, fetch latest username from Firebase API
    if (uid != null && idToken != null) {
      await userProvider.fetchUserNameFromApi(uid, idToken);
    }
    await checkSessionAndNavigate();
  }

  Future<void> checkSessionAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');
    await Future.delayed(const Duration(seconds: 2));
    if (refreshToken == null) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) =>
                  const OnboardingScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(scale: animation, child: child);
          },
        ),
      );
      return;
    }
    try {
      final response = await http.post(
        Uri.parse(Apiservice.refreshToken),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'grant_type': 'refresh_token',

          'refresh_token': refreshToken,
        }),
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        await prefs.setString('idToken', result['id_token']);
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) => const Bottomnav(),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return ScaleTransition(scale: animation, child: child);
            },
          ),
        );
      } else {
        prefs.clear();
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) => const Loginpage(),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return ScaleTransition(scale: animation, child: child);
            },
          ),
        );
      }
    } catch (e) {
      prefs.clear();
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => const Loginpage(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(scale: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            SizedBox(height: 50.h),
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
    );
  }
}
