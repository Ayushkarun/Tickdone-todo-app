import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tickdone/Screens/Register/register.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior
                  .onDrag, //scroll the screen, the keyboard close.
          child: Padding(
            padding: EdgeInsets.all(11.w),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 7.h),
                Image.asset('assets/images/Logo/logofinal.png', height: 60.h),
                SizedBox(height: 10.h),
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 23.sp,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Let’s finish those tasks!',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 18.h),

                Text(
                  'E-mail',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 6.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: TextFormField(
                    style: TextStyle(fontSize: 14.sp),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.mail, size: 22.sp),
                      hintText: 'Enter Email',
                      hintStyle: TextStyle(fontSize: 14.sp),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 10.w,
                      ), //inside
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                Text(
                  'Password',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 6.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: TextFormField(
                    style: TextStyle(fontSize: 14.sp),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.password, size: 22.sp),
                      hintText: 'Enter Password',
                      hintStyle: TextStyle(fontSize: 14.sp),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 10.w,
                      ), //inside
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                Center(
                  child: SizedBox(
                    height: 45.h,
                    width: 0.65.sw,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C0E6F),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                Center(
                  child: SizedBox(
                    height: 45.h,
                    width: 0.53.sw,
                    child: OutlinedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/google.png', height: 16.h),
                          SizedBox(width: 8.w),
                          Text(
                            'Continue with Google',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),

                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: const Color.fromARGB(104, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5.h),

                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.white, thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        'or',
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.white, thickness: 1)),
                  ],
                ),
                SizedBox(height: 5.h),
                Center(
                  child: SizedBox(
                    height: 45.h,
                    width: 0.85.sw,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Register()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C0E6F),
                      ),
                      child: Text(
                        'Create an Account',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
