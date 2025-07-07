import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class OnboardingCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;

  const OnboardingCard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.85.sh,
      width: 1.sw,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 0.10.sw,
              vertical: 0.05.sh,
            ),
            child: Image.asset(image, fit: BoxFit.contain, height: 0.35.sh),
          ),
          Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(14.w),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style:TextStyle(fontFamily: 'Poppins',color: Colors.white, fontSize: 14.sp),
                ),
              ),
            ],
          ),

          SizedBox(height: 0.08.sh),

          Padding(
            padding: EdgeInsets.only(bottom: 0.03.sh),
            child: MaterialButton(
              onPressed: onPressed,
              color: const Color.fromARGB(255, 35, 21, 118),
              minWidth: 0.9.sw,
              height: 0.06.sh,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
