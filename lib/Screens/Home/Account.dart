import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tickdone/Screens/Authentication/Login/login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tickdone/Service/Provider/user_provider.dart';
import 'Aboutus.dart';
import 'package:http/http.dart' as http;
import 'package:tickdone/Service/Api/api_service.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String? _userName; // To store the user's name
  bool _isProfileLoading = true; // To show a loading spinner
  @override
  void initState() {
    super.initState();
    // Fetch the user's profile as soon as the widget is created
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userUID');
    final idToken = prefs.getString('idToken');

    if (uid == null || idToken == null) {
      setState(() => _isProfileLoading = false);
      return;
    }

    final url = Uri.parse(
      '${Apiservice.firestoreBaseUrl}/users/$uid?key=${Apiservice.apiKey}',
    );
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $idToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Find the 'name' field and get its 'stringValue'
        setState(() {
          _userName = data['fields']?['name']?['stringValue'] ?? "";
        });
      }
    } catch (e) {
      // Handle error if needed
    } finally {
      setState(() => _isProfileLoading = false);
    }
  }

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

  void showChangeNameDialog() {
    final TextEditingController nameController = TextEditingController();
    final nameKey = GlobalKey<FormState>();
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
            "Change Name",
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
                "Enter Your New Name.",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white70, // Slightly dimmer for better UI
                  fontSize: 12.sp,
                ),
              ),
              Form(
                key: nameKey,
                child: TextFormField(
                  controller: nameController,
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  decoration: InputDecoration(
                    labelText: "Name",
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
                      return 'Name cannot be empty';
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
                if (nameKey.currentState!.validate()) {
                  final newName = nameController.text.trim();
                  updateUserName(newName);
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                "Save",
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

  void Changeemaildialog() {
    final TextEditingController newMailController = TextEditingController();
    final formkey = GlobalKey<FormState>();
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.87),
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(18.r),
          ),
          title: Text(
            "Change Email",
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
                "Enter Your New Email Address.",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white70,
                  fontSize: 12.sp,
                ),
              ),
              Form(
                key: formkey,
                child: TextFormField(
                  controller: newMailController,
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  decoration: InputDecoration(
                    labelText: "New Email",
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF1C0E6F)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email cannot be empty';
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
              onPressed: () {
                Navigator.of(context).pop();
              },
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
                if (formkey.currentState!.validate()) {
                  final newMail = newMailController.text.trim();
                  changeEmail(newMail);
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                "Save",
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

  Future<void> changeEmail(String newMail) async {
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('idToken');

    if (idToken == null) {
      return;
    }

    final url = Uri.parse(Apiservice.changeEmail);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'idToken': idToken,
          'email': newMail,
          'returnSecureToken': true,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final newIdToken = responseData['idToken'];
        final newRefreshToken = responseData['refreshToken'];

        await prefs.setString('idToken', newIdToken);
        await prefs.setString('refreshToken', newRefreshToken);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Success!',
              message: 'Email changed successfully!',
              contentType: ContentType.success,
            ),
          ),
        );
      } else {
        final errorData = json.decode(response.body);
        String errorMessage = "An error occurred. Please try again.";
        if (errorData['error'] != null &&
            errorData['error']['message'] != null) {
          errorMessage = errorData['error']['message'];
        }

        if (errorMessage == "EMAIL_EXISTS") {
          errorMessage = "This email is already in use by another account.";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Oh Snap!',
              message: errorMessage,
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
            message:
                'Something went wrong. Please check your network connection.',
            contentType: ContentType.failure,
          ),
        ),
      );
    }
  }

  Future<void> updateUserName(String newName) async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userUID');
    final idToken = prefs.getString('idToken');

    final url = Uri.parse(
      '${Apiservice.firestoreBaseUrl}/users/$uid?updateMask.fieldPaths=name&key=${Apiservice.apiKey}',
    );

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: json.encode({
        'fields': {
          'name': {'stringValue': newName},
        },
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Success',
            message: 'Name updated successfully!',
            contentType: ContentType.success,
          ),
        ),
      );
      Provider.of<UserProvider>(context, listen: false).setUserName(newName);
      // _fetchUserProfile();
      // setState(() {
      //   _userName = newName;
      // });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Failed',
            message: 'Failed to update Name',
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
                "Enter email to get a password change link.",
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
    final userName = Provider.of<UserProvider>(context).userName;
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
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
                                gradient: const LinearGradient(
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
                                    if (_isProfileLoading)
                                      const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    else
                                      Text(
                                        userName.isEmpty ? "User" : userName,
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
                        onPressed: showChangeNameDialog,
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
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          return Changeemaildialog();
                        },
                        icon: Icon(
                          Icons.mail,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        label: Text(
                          'Change Email',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),

                      TextButton.icon(
                        onPressed: () => showForgotPasswordDialog(),
                        icon: Icon(Icons.key, color: Colors.white, size: 24.sp),
                        label: Text(
                          'Change Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => Aboutus(),
                              transitionsBuilder: (_, animation, __, child) {
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
                            fontFamily: 'Poppins',
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
                ),
              ),

              // --- THE STICKY FOOTER CONTENT GOES HERE ---
              // It is outside the Expanded widget, so it's pushed to the bottom.
              Column(
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      Navigator.pushAndRemoveUntil(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const Loginpage(),
                          transitionsBuilder: (_, animation, __, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 500),
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
                      style: TextStyle(color: Colors.red, fontSize: 16.sp),
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
    );
  }
}
