import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tickdone/Screens/Login/login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 50.h,
        bottom: 18.h,
        left: 10.w,
        right: 10.w,
      ),
      color: Colors.black,
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.black, size: 60.sp),
          ),

          SizedBox(height: 10.h),
          Text(
            'Account',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 28.sp,
            ),
          ),
          SizedBox(height: 40.h),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, color: Colors.white, size: 30.sp),
                      SizedBox(width: 5.w),
                      Text(
                        'Change Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.key, color: Colors.white, size: 30.sp),
                      SizedBox(width: 5.w),
                      Text(
                        'Change Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info, color: Colors.white, size: 30.sp),
                      SizedBox(width: 5.w),
                      Text(
                        'About Us',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 100.h),
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Help & Feedback',
                style: TextStyle(color: Colors.white, fontFamily: 'Poppins',fontSize: 16.sp,),
              ),
            ),
          ),
         SizedBox(height: 80.h),
          Center(
            child: TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Loginpage()),
                  (route) => false,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_sharp, color: Colors.red,size: 25.sp),
                  SizedBox(width: 2.w),
                  Text(
                    'Log out',
                    style: TextStyle(color: Colors.red, fontFamily: 'Poppins',fontSize: 16.sp,),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
