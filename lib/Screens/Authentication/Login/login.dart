 import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:tickdone/Service/api_service.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tickdone/Screens/Home/bottomnav.dart';

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

  // FORGOT PASSWORD
  
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
              message: 'Password reset link sent to your email.',
              contentType: ContentType.success,
            ),
          ),
        );
      } else {
        final result = json.decode(response.body);
        String displayMessage = "An error occurred. Please try again.";
        if (result.containsKey("error") &&
            result["error"].containsKey("message")) {
          final errorMessage = result["error"]["message"];
          if (errorMessage == "EMAIL_NOT_FOUND") {
            displayMessage = "No user found with this email.";
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Oh Snap!',
              message: displayMessage,
              contentType: ContentType.failure,
            ),
          ),
        );
      }
    } catch (e) {
      // Handle network or other unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error!',
            message: 'Something went wrong. Please check your connection.',
            contentType: ContentType.failure,
          ),
        ),
      );
    }
  }

  void showForgotPasswordDialog() {
    final TextEditingController emailControllerforgot = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            "Forgot Password",
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20.sp,
            ),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: emailControllerforgot,
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
              decoration: InputDecoration(
                labelText: "Enter your email",
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

  //login
  Future<void> logIn() async {
    setState(() {
      isLoading = true;
    });
    final email = emailcontrollerlogin.text;
    final password = passwordControllerlogin.text;

    try {
      final response = await http.post(
        Uri.parse(Apiservice.login),
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
        emailcontrollerlogin.clear();
        passwordControllerlogin.clear();
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => Bottomnav(),
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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Login Successful!',
              message: 'Welcome back!',
              contentType: ContentType.success,
            ),
          ),
        );
      } else {
        String displayMessage = "Login failed. Please try again.";

        if (result.containsKey("error") &&
            result["error"].containsKey("message")) {
          final errorMessage = result["error"]["message"];

          if (errorMessage == "EMAIL_NOT_FOUND") {
            displayMessage = "No user found with this email.";
          } else if (errorMessage == "INVALID_PASSWORD") {
            displayMessage = "Incorrect password.";
          } else if (errorMessage == "INVALID_LOGIN_CREDENTIALS") {
            displayMessage = "Email or password is incorrect.";
          } else if (errorMessage == "USER_DISABLED") {
            displayMessage = "This user account has been disabled.";
          } else {
            displayMessage =
                errorMessage; 
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Login Failed!',
              message: displayMessage,
              contentType: ContentType.failure,
            ),
          ),
        );
      }
    } catch (e) {
      // If there's any unexpected issue (like network failure)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error!',
            message: 'Something went wrong. Please try again.',
            contentType: ContentType.failure,
          ),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  //sign in with google
  Future<void> signInwithGoogle() async {
    try {
      setState(() {
        isLoading = true;
      });
      await GoogleSignIn().signOut();

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
      final result = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('idToken', result['idToken']);
        await prefs.setString('refreshToken', result['refreshToken']);

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => Bottomnav(),
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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Register Successful!',
              message: 'Welcome !',
              contentType: ContentType.success,
            ),
          ),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        // If Firebase gives an error, show it.
        final data = json.decode(response.body);
        final message =
            data['error']['message'] ?? 'An unknown error occurred.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Login Failed!',
              message: message,
              contentType: ContentType.failure,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // If anything else goes wrong, show a general error.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error!',
            message: 'An error occurred: ${e.toString()}',
            contentType: ContentType.failure,
          ),
        ),
      );
    }
  }

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
                              logIn();
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 20.h),

                      Center(
                        child: SizedBox(
                          height: 45.h,
                          width: 0.65.sw,
                          child: ElevatedButton(
                            onPressed: () {
                              if (loginkey.currentState!.validate()) {
                                logIn();
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
                              signInwithGoogle();
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
                      SizedBox(height: 14.h),

                      Center(
                        child: TextButton(
                          onPressed: () {
                            showForgotPasswordDialog();
                          },
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
                              emailcontrollerlogin.clear();
                              passwordControllerlogin.clear();
                              Navigator.pop(context);
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
