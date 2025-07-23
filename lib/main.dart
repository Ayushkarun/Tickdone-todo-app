 import 'package:flutter/material.dart';
import 'package:tickdone/Screens/splash%20screen/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_core/firebase_core.dart';


void main() async
{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    // These two lines are essential
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.delayed(Duration(seconds: 1),);
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


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tickdone/Screens/Home/home.dart';
// import 'package:tickdone/Screens/splash%20screen/splash_screen.dart';

// void main() async {
//   WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
//   await Future.delayed(const Duration(seconds: 2));
//   FlutterNativeSplash.remove();
//   runApp(const Tickdone());
// }

// class Tickdone extends StatelessWidget {
//   const Tickdone({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: ScreenUtil.defaultSize,
//       builder: (context, child) => MaterialApp(
//         title: 'Tickdone',
//         debugShowCheckedModeBanner: false,
//         // This StreamBuilder is the app's "security guard".
//         // It listens for login/logout events from Firebase.
//         home: StreamBuilder<User?>(
//           stream: FirebaseAuth.instance.authStateChanges(),
//           builder: (context, snapshot) {
//             // If the snapshot has data, a user is logged in!
//             if (snapshot.hasData) {
//               return const Home(); // Go directly to the Home screen.
//             }
//             // Otherwise, no user is logged in.
//             return const SplashScreen(); // Start with the splash screen.
//           },
//         ),
//       ),
//     );
//   }
// }
