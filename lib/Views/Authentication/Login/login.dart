import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tickdone/Services/auth/loginauth.dart';
import 'package:tickdone/Views/Authentication/Register/register.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tickdone/Views/Widget/pageTransition.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final FocusNode emailfocus = FocusNode();
  final FocusNode passwordfocus = FocusNode();
  final TextEditingController emailcontrollerlogin = TextEditingController();
  final TextEditingController passwordControllerlogin = TextEditingController();
  bool passwordhide = true;
  IconData iconhide = Icons.visibility_off;
  bool isLoading = false;

  final loginkey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  @override
  void dispose() {
    emailfocus.dispose();
    passwordfocus.dispose();
    emailcontrollerlogin.dispose();
    passwordControllerlogin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior
                      .onDrag, //scroll the screen, the keyboard close.
              child: Padding(
                padding: EdgeInsets.all(11.w),

                child: Form(
                  key: loginkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 7.h),
                      Image.asset(
                        'assets/images/Logo/logofinal.png',
                        height: 60.h,
                      ),
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
                          autofocus: false,
                          focusNode: emailfocus,

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email';
                            }
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                          controller: emailcontrollerlogin,
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
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(passwordfocus);
                          },
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
                          focusNode: passwordfocus,
                          autofocus: false,
                          obscureText: passwordhide,
                          controller: passwordControllerlogin,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Password';
                            }
                            if (value.length < 6) {
                              return 'Password must be more than 6 characters';
                            }
                            if (!RegExp(
                              r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]+$',
                            ).hasMatch(value)) {
                              return 'Password must contain letters and numbers only';
                            }
                            return null;
                          },
                          style: TextStyle(fontSize: 14.sp),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.password, size: 22.sp),
                            hintText: 'Enter Password',
                            hintStyle: TextStyle(fontSize: 14.sp),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (passwordhide == true) {
                                    passwordhide = false;
                                    iconhide = Icons.visibility;
                                  } else {
                                    passwordhide = true;
                                    iconhide = Icons.visibility_off;
                                  }
                                });
                              },
                              icon: Icon(iconhide),
                            ),

                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12.h,
                              horizontal: 10.w,
                            ), //inside
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (value) {
                            if (loginkey.currentState!.validate()) {
                              setState(() => isLoading = true);
                              authService
                                  .logIn(
                                    context,
                                    emailcontrollerlogin.text.trim(),
                                    passwordControllerlogin.text.trim(),
                                  )
                                  .whenComplete(() {
                                    setState(() => isLoading = false);
                                  });
                            }
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            authService.showForgotPasswordDialog(context);
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 17.h),

                      Center(
                        child: SizedBox(
                          height: 45.h,
                          width: 0.65.sw,
                          child: ElevatedButton(
                            onPressed: () {
                              if (loginkey.currentState!.validate()) {
                                setState(() => isLoading = true);
                                authService
                                    .logIn(
                                      context,
                                      emailcontrollerlogin.text.trim(),
                                      passwordControllerlogin.text.trim(),
                                    )
                                    .whenComplete(() {
                                      setState(() => isLoading = false);
                                    });
                              }
                            },
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
                            onPressed: () {
                              authService.signInWithGoogle(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/google.png',
                                  height: 16.h,
                                ),
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
                      SizedBox(height: 20.h),

                      Center(
                        child: Text(
                          '2025 @All Rights Reserved',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 8.sp,
                            color: Colors.white60,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),

                      Row(
                        children: [
                          Expanded(
                            child: Divider(color: Colors.white, thickness: 1),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Text(
                              'or',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(color: Colors.white, thickness: 1),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Center(
                        child: SizedBox(
                          height: 45.h,
                          width: 0.85.sw,
                          child: ElevatedButton(
                            onPressed: () {
                              emailcontrollerlogin.clear();
                              passwordControllerlogin.clear();
                              Navigator.push(
                                context,
                                FadeInTransition(page: const Register()),
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
          ),
          if (isLoading)
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: SpinKitDoubleBounce(color: Colors.white, size: 70.w),
              ),
            ),
        ],
      ),
    );
  }
}
