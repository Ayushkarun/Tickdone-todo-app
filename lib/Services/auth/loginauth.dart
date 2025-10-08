import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:tickdone/Views/Home/Createprofile.dart';
import 'package:tickdone/Views/Home/bottomnav.dart';
import 'package:tickdone/Views/Widget/pageTransition.dart';
import 'package:tickdone/Views/Widget/snackBar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tickdone/Services/Api/api_service.dart';

class AuthService {
  Future<void> checkProfileAndNavigate(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userUID');
    final idToken = prefs.getString('idToken');

    final url = Uri.parse(
      '${Apiservice.firestoreBaseUrl}/users/$uid?key=${Apiservice.apiKey}',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $idToken'},
      );

      if (response.statusCode == 404) {
        Navigator.pushReplacement(
          context,
          FadeInTransition(page: const Createprofile()),
        );
      } else if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          FadeInTransition(page: const Bottomnav()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          FadeInTransition(page: const Bottomnav()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('An error Occurred')));
    }
  }

  Future<void> forgotPassword(BuildContext context, String email) async {
    try {
      final response = await http.post(
        Uri.parse(Apiservice.forgotPassword),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'requestType': 'PASSWORD_RESET', 'email': email}),
      );

      if (response.statusCode == 200) {
        Mysnackbar.detail(
          context,
          title: 'Success!',
          message: 'Password reset link sent to your email.',
          contentType: ContentType.success,
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
        Mysnackbar.detail(
          context,
          title: 'Oh Snap!',
          message: displayMessage,
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      Mysnackbar.detail(
        context,
        title: 'Error!',
        message: 'Something went wrong. Please check your connection.',
        contentType: ContentType.failure,
      );
    }
  }

  void showForgotPasswordDialog(BuildContext context) {
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
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1C0E6F)),
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
                  forgotPassword(context, emailControllerforgot.text.trim());
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

  Future<void> logIn(
    BuildContext context,
    String email,
    String password,
  ) async {
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

        await checkProfileAndNavigate(context);

        Mysnackbar.detail(
          context,
          title: 'Login Successful!',
          message: 'Welcome back!',
          contentType: ContentType.success,
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
            displayMessage = errorMessage;
          }
        }

        Mysnackbar.detail(
          context,
          title: 'Login Failed!',
          message: displayMessage,
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      Mysnackbar.detail(
        context,
        title: 'Error!',
        message: 'Something went wrong. Please try again.',
        contentType: ContentType.failure,
      );
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      await GoogleSignIn().signOut();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
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
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('idToken', result['idToken']);
        await prefs.setString('refreshToken', result['refreshToken']);
        await prefs.setString('userUID', result['localId']);

        await checkProfileAndNavigate(context);

        Mysnackbar.detail(
          context,
          title: 'Register Successful!',
          message: 'Welcome !',
          contentType: ContentType.success,
        );
      } else {
        final data = json.decode(response.body);
        final message =
            data['error']['message'] ?? 'An unknown error occurred.';
        Mysnackbar.detail(
          context,
          title: 'Login Failed!',
          message: message,
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      Mysnackbar.detail(
        context,
        title: 'Error!',
        message: 'An error occurred: ${e.toString()}',
        contentType: ContentType.failure,
      );
    }
  }
}
