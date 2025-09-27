import 'dart:convert';

///validation snakbar
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:tickdone/Views/Authentication/Login/login.dart';
import 'package:tickdone/Services/Api/api_service.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tickdone/Views/Home/Createprofile.dart';
import 'package:tickdone/Views/Widget/snackBar.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordcontroller =
      TextEditingController();
  bool isLoading = false;

  bool passwordhide = true;
  IconData iconhide = Icons.visibility_off;
  bool confpasswordhide = true;
  IconData conficonhide = Icons.visibility_off;

  final key = GlobalKey<FormState>();

  Future<void> signUp() async {
    setState(() {
      isLoading = true;
    });
    final email = emailController.text;
    final password = passwordController.text;

    try {
      final response = await http.post(
        Uri.parse(Apiservice.register),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }),
      );

      final result = json.decode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('idToken', result['idToken']);
        await prefs.setString('refreshToken', result['refreshToken']);
        await prefs.setString('userUID', result['localId']);
        // Success
        emailController.clear();
        passwordController.clear();
        confirmpasswordcontroller.clear();
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) => Createprofile(),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );

        Mysnackbar.detail(
          context,
          title: 'Register Successful!',
          message: 'Welcome !',
          contentType: ContentType.success,
        );
      } else {
        // Error occurred
        final errorMessage = result["error"]["message"];
        String displayMessage = "Registration failed. Please try again.";

        if (errorMessage == "EMAIL_EXISTS") {
          displayMessage = "Email already exists. Try logging in.";
        } else if (errorMessage == "WEAK_PASSWORD") {
          displayMessage = "Password too weak. Use at least 6 characters.";
        } else if (errorMessage == "INVALID_EMAIL") {
          displayMessage = "Please enter a valid email address.";
        } else if (errorMessage == "TOO_MANY_ATTEMPTS_TRY_LATER") {
          displayMessage = "Too many attempts. Try again later.";
        }

        // Show snackbar

        Mysnackbar.detail(
          context,
          title: 'Register Failed!',
          message: displayMessage,
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      // Network error or unexpected error
      Mysnackbar.detail(
        context,
        title: 'Error!',
        message: 'Something went wrong. Please try again.',
        contentType: ContentType.failure,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> registerwithGoogle() async {
    try {
      setState(() {
        isLoading = true;
      });
      // Force show account chooser every time
      await GoogleSignIn().signOut();
      // Choose an account
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        setState(() {
          isLoading = false;
        });
        throw Exception('Could not get Google ID Token.');
      }

      final response = await http.post(
        Uri.parse(Apiservice.googleSignIn),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "postBody": "id_token=$idToken&providerId=google.com",
          "requestUri": "http://localhost",
          "returnSecureToken": true,
          "returnIdpCredential": true,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        final result = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('idToken', result['idToken']);
        await prefs.setString('refreshToken', result['refreshToken']);
        await prefs.setString('userUID', result['localId']);

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    const Createprofile(),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
        Mysnackbar.detail(
          context,
          title: 'Register Successful!',
          message: 'Welcome !',
          contentType: ContentType.success,
        );
      } else {
        setState(() {
          isLoading = false;
        });
        // If Firebase gives an error, show it.
        final data = json.decode(response.body);
        final message =
            data['error']['message'] ?? 'An unknown error occurred.';
        Mysnackbar.detail(
          context,
          title: 'Register Failure!',
          message: message,
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Mysnackbar.detail(
        context,
        title: 'Error',
        message: 'An error occurred: ${e.toString()}',
        contentType: ContentType.failure,
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordcontroller.dispose();
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
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

              padding: EdgeInsets.all(11.w),
              child: Form(
                key: key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 7.h),
                    Image.asset(
                      'assets/images/Logo/logofinal.png',
                      height: 60.h,
                    ),
                    SizedBox(height: 7.h),
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
                      "Start managing your tasks today.",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white70,
                        fontSize: 14.sp,
                      ),
                    ),

                    SizedBox(height: 10.h),
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
                        controller: emailController,
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
                        controller: passwordController,
                        obscureText: passwordhide,
                        style: TextStyle(fontSize: 14.sp),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.password, size: 22.sp),
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
                            icon: Icon(iconhide, size: 22.sp),
                          ),
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
                          if (value != passwordController.text) {
                            return 'Password dont match';
                          }
                          return null;
                        },
                        controller: confirmpasswordcontroller,
                        obscureText: confpasswordhide,
                        style: TextStyle(fontSize: 14.sp),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.password, size: 22.sp),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                if (confpasswordhide == true) {
                                  confpasswordhide = false;
                                  conficonhide = Icons.visibility;
                                } else {
                                  confpasswordhide = true;
                                  conficonhide = Icons.visibility_off;
                                }
                              });
                            },
                            icon: Icon(conficonhide, size: 22.sp),
                          ),
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
                          onPressed: () {
                            if (key.currentState!.validate()) {
                              signUp();
                            }
                          },
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
                          onPressed: () {
                            registerwithGoogle();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/google.png',
                                height: 10.h,
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

                    SizedBox(height: 14.h),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'By Registering you agree to our',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Privacy Policy',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Color.fromARGB(255, 119, 95, 253),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Center(
                      child: Text(
                        '2025 @All Rights Reserved',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 9.sp,
                          color: Colors.white60,
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
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
                    SizedBox(height: 5.h),

                    Center(
                      child: SizedBox(
                        height: 45.h,
                        width: 0.85.sw,
                        child: ElevatedButton(
                          onPressed: () {
                            emailController.clear();
                            passwordController.clear();
                            confirmpasswordcontroller.clear();
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        Loginpage(),
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1C0E6F),
                          ),
                          child: Text(
                            'Already registered? Log in',
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
          if (isLoading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: SpinKitDoubleBounce(color: Colors.white, size: 70.0.w),
              ),
            ),
        ],
      ),
    );
  }
}
