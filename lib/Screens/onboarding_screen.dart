import 'package:flutter/material.dart';
import 'onboarding_screendata.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child:PageView.builder(
          itemCount: listdata.length,
          itemBuilder: (context,index)
          {
            OnboardingScreendata boarding=listdata[index];
            return Container(
              child: Column(
                children: [
                  Expanded(child: Text(boarding.title))
                ],
              ),
            );
          })
      ),

    );
  }
}