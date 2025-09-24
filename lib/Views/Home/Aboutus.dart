import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Aboutus extends StatelessWidget {
  const Aboutus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Image.asset(
              "assets/images/Logo/logofinal.png",
              width: 0.15.sw,
              height: 0.10.sh,
            ),
            SizedBox(height: 5.h),
            Center(
              child: Text(
                'TICKDONE',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.sp,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Center(
              child: Text(
                'Tick a Task,Get it Done.',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 13.sp,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Center(
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Text(
                  'TickDone is a Flutter-based Todo app developed by Ayush Karun as part of his project, aimed at helping users manage their daily tasks efficiently. This project was also an opportunity to learn and showcase my Flutter development skills.',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 15.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Center(
              child: Text(
                'Contact: ayushkarun2580@gmail.com',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 11.sp,
                ),
              ),
            ),
            Center(
              child: Text(
                'By Ayush Karun',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Center(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
