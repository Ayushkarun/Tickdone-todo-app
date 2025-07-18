import 'package:flutter/material.dart';
import 'package:tickdone/Screens/splash%20screen/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:firebase_core/firebase_core.dart';

void main() async
{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.delayed(Duration(seconds: 2),);
  FlutterNativeSplash.remove();
  // await Firebase.initializeApp();
  runApp(const Tickdone());
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