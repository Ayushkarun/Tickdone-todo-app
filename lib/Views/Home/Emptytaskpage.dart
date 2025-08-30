import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Emptytask extends StatelessWidget {
  const Emptytask({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10.h),
          Image.asset(
            'assets/images/NoTaskstick.png',
            width: 200.w,
            height: 150.h,
          ),
          SizedBox(height: 20.h),
          Text(
            'You have no tasks for today!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Add a new task using the + button.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.sp,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}