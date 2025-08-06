import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tickdone/Screens/Login/login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Aboutus.dart';
// import 'package:url_launcher/url_launcher.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
 Future<void> helpalert(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          
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
              style: TextStyle(color: Colors.lightBlueAccent, fontSize: 14.sp),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Ok', style: TextStyle(color:Colors.white,fontFamily: 'Poppins')),
          ),
         
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 18.h),
            color: Colors.black,
            height: constraints.maxHeight, // Use available height
            width: double.infinity,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Distribute space
              children: [
                Column(
                  children: [
                    SizedBox(height: 20.h),
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
                      'Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 24.sp,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                      label: Text(
                        'Change Name',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.key, color: Colors.white, size: 24.sp),
                      label: Text(
                        'Change Password',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Aboutus()),
                        );
                      },
                      icon: Icon(Icons.info, color: Colors.white, size: 24.sp),
                      label: Text(
                        'About Us',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        helpalert(context);
                      },
                      child: Text(
                        'Help & Feedback',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextButton.icon(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Loginpage()),
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
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
