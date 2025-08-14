import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:blurrycontainer/blurrycontainer.dart';

// --- The Blueprint ---
// A StatefulWidget is the blueprint for a screen that can change.
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

// --- The Brain ---
// The State class is the "brain" of our widget. It holds all the variables
// and logic that make the screen work.
class _HomeState extends State<Home> {
  // The 'build' method is like an assembly line. Its job is to build the
  // visual part of your widget.
  @override
  Widget build(BuildContext context) {
    // --- The Foundation ---
    // A Container is like an empty box. We use it here as the foundation for
    // our screen and to give it a black background color.
    return Container(
      color: Colors.black,
      // SafeArea is a safety net. It adds padding automatically to prevent
      // your app's UI from being hidden by the phone's notch or status bar.
      child: SafeArea(
        child: Padding(
          // Padding adds space around the edges of its child.
          padding: EdgeInsets.only(
            top: 20.h,
            bottom: 5.h,
            left: 15.w,
            right: 15.w,
          ),
          // --- The Main Layout ---
          // A Column is like stacking books. It arranges its children
          // vertically, one on top of the other.
          child: Column(
            // This tells the Column to align all its children to the left.
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- The Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Hello, Ayush Karun!',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 27.sp,
                    ),
                  ),
                ],
              ),
              // SizedBox is just an invisible, empty box for creating space.
              SizedBox(height: 30.h),

              // --- Card with glowing circles ---
              Center(
                // This is the main background container for the card effect.
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.92,
                  height: 140.h,
                  // ClipRRect acts like scissors, trimming the contents (the circles)
                  // to match the rounded corners of the container.
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Dark Purple/Blue glow circle (top-left)
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

                        // Mid-Blue/Bright Purple glow circle (bottom-right)
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

                        // The smaller, frosted glass card that sits on top.
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
