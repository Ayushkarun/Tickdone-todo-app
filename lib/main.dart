import 'package:flutter/material.dart';
import 'package:tickdone/Screens/splash%20screen/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main()
{
  runApp(Tickdone());
}

class Tickdone extends StatelessWidget {
  const Tickdone({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: ScreenUtil.defaultSize,
      builder: (context, child) => 
      MaterialApp(
        title: 'Tickdone',
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}