import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tickdone/Screens/Login/login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Aboutus.dart';
import 'package:http/http.dart' as http;
import 'package:tickdone/Service/api_service.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  Future<void> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse(Apiservice.forgotPassword),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'requestType': 'PASSWORD_RESET', 'email': email}),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Success!',
              message: 'Password Change Link sent to your mail',
              contentType: ContentType.success,
            ),
          ),
        );
      } else {
        final result = json.decode(response.body);
        String displayMessage = "An error occurred. Please try again";
        if (result.containsKey("error") &&
            result["error"].containsKey("message")) {
          final errorMessage = result["error"]["message"];
          if (errorMessage == "EMAIL_NOT_FOUND") {
            displayMessage = "No user found with this email";
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            content: AwesomeSnackbarContent(
              title: 'oh snap!',
              message: displayMessage,
              contentType: ContentType.failure,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error!',
            message: 'Something went wrong.Please check network connection',
            contentType: ContentType.failure,
          ),
        ),
      );
    }
  }

  Future<void> helpalert(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(15.r),
          ),
          title: Text(
            'Send Feedback?',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 20.sp,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please Mail us on\n',
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              ),
              Text(
                'tickdoneapp@gmail.com',
                style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
              ),
            ),
          ],
        );
      },
    );
  }

  void showForgotPasswordDialog() {
    final TextEditingController emailControllerforgot = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.87),
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(18.r),
          ),
          title: Text(
            "Change Password",
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20.sp,
            ),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter email to get a password reset link.",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white70, // Slightly dimmer for better UI
                  fontSize: 12.sp,
                ),
              ),
              Form(
                key: formKey,
                child: TextFormField(
                  controller: emailControllerforgot,
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFF1C0E6F)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C0E6F),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  forgotPassword(emailControllerforgot.text.trim());
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                "Send Link",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween, // Pushes bottom part down
                      children: [
                        Column(
                          children: [
                            // Profile card
                            Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.95,

                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40.r),
                                  ),
                                  elevation: 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF10083F),
                                          Color(0xFF2B1B80),
                                          Color(0xFF5C39FF),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 7.h,
                                        horizontal: 2.w,
                                      ),
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 35.r,
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.black,
                                              size: 40.sp,
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(
                                            'Ayush Karun',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 25.h),

                            // Buttons
                            TextButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                              label: Text(
                                'Change Name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => showForgotPasswordDialog(),
                              icon: Icon(
                                Icons.key,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                              label: Text(
                                'Change Password',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => Aboutus(),
                                    transitionsBuilder: (
                                      _,
                                      animation,
                                      __,
                                      child,
                                    ) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.info,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                              label: Text(
                                'About Us',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => helpalert(context),
                              child: Text(
                                'Help & Feedback',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Bottom logout + version info
                        Column(
                          children: [
                            TextButton.icon(
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.clear();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => Loginpage(),
                                    transitionsBuilder: (
                                      _,
                                      animation,
                                      __,
                                      child,
                                    ) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                    transitionDuration: Duration(
                                      milliseconds: 500,
                                    ),
                                  ),
                                  (route) => false,
                                );
                              },
                              icon: Icon(
                                Icons.logout_sharp,
                                color: Colors.red,
                                size: 24.sp,
                              ),
                              label: Text(
                                'Log out',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Version 1.0.0',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10.sp,
                                color: Colors.white60,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'ALL RIGHTS RESERVED',
                              style: TextStyle(
                                fontSize: 8.sp,
                                fontFamily: 'Poppins',
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
