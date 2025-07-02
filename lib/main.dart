import 'package:flutter/material.dart';
import 'package:tickdone/Screens/splash%20screen/splash_screen.dart';

void main()
{
  runApp(Tickdone());
}

class Tickdone extends StatelessWidget {
  const Tickdone({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tickdone',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}