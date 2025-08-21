import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:provider/provider.dart';
import 'package:tickdone/Services/Provider/user_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,

      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 20.h,
            bottom: 5.h,
            left: 15.w,
            right: 15.w,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      String displayName = "User";
                      if (userProvider.userName.isNotEmpty) {
                        displayName = userProvider.userName;
                      }

                      return Text(
                        'Hello, $displayName!',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 27.sp,
                        ),
                      );
                    },
                  ),
                ],
              ),

              SizedBox(height: 30.h),

              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.92,
                  height: 140.h,

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: -40.h,
                          left: -40.w,
                          child: Container(
                            width: 160.w,
                            height: 160.h,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF10083F), // Darkest purple
                                  Color(0xFF2B1B80), // Mid-blue
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: -50.h,
                          right: -50.w,
                          child: Container(
                            width: 180.w,
                            height: 180.h,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF2B1B80), // Mid-blue
                                  Color(0xFF5C39FF), // Brightest purple
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                        ),

                        BlurryContainer(
                          blur: 15,
                          width: MediaQuery.of(context).size.width * 0.80,
                          height: 110.h,
                          elevation: 0,
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20.r),
                          padding: const EdgeInsets.all(0),
                          child: const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
