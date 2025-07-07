import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

          padding: EdgeInsets.all(11.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 7.h),
              Image.asset('assets/images/Logo/logofinal.png', height: 60.h),
              SizedBox(height: 10.h),
              Text(
                'Register',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 23.sp,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                'E-mail',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(height: 5.h),
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
              SizedBox(height: 7.h),
              Text(
                'Password',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(height: 5.h),
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
              SizedBox(height: 7.h),
              Text(
                'Confirm Password',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(height: 5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: TextFormField(
                  style: TextStyle(fontSize: 14.sp),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.password, size: 22.sp),
                    hintText: 'Confirm Password',
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
                      backgroundColor: Color(0xFF1C0E6F),
                    ),
                    child: Text(
                      'Create a account',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                        Image.asset('assets/images/google.png', height: 10.h),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'By Registering you agree to our',
                      style: TextStyle(fontSize: 10.sp, color: Colors.white),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      'Privacy Policy',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Color.fromARGB(255, 119, 95, 253),
                      ),
                    ),
                  ],
                ),
              ),

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
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C0E6F),
                    ),
                    child: Text('Already registered? Log in', style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),),
                  ),
                ),
              ),
                SizedBox(height: 1.h),
            ],
          ),
        ),
      ),
    );
  }
}
