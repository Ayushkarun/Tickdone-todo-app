import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickdone/Screens/Splashscreen/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tickdone/Service/Provider/nameprovider.dart';
// import 'package:provider/provider.dart';

// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.delayed(Duration(seconds: 1));
  FlutterNativeSplash.remove();
  runApp(const Tickdone());
}

class Tickdone extends StatelessWidget {
  const Tickdone({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserNameProvider(),),
      ],
      child: ScreenUtilInit(
        designSize: ScreenUtil.defaultSize,
        builder:
            (context, child) => MaterialApp(
              title: 'Tickdone',
              debugShowCheckedModeBanner: false,
              home: SplashScreen(),
            ),
      ),
    );
  }
}
