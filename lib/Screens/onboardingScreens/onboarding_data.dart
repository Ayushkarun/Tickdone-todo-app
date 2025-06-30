import 'package:flutter/material.dart';

class Onboardingcard extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String buttonText;
  final Function onPressed;

  const Onboardingcard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Screen height and width
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: screenHeight * 0.85, // Slightly adjusted
      width: screenWidth,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image Section
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.1,
              vertical: screenHeight * 0.05,
            ),
            child: Image.asset(
              image,
              fit: BoxFit.contain,
              height: screenHeight * 0.35, // Image takes 35% of screen height
            ),
          ),

          // Text Section
          Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.08, // Responsive font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                  screenWidth * 0.04,
                ), // Responsive padding
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04, // Responsive font size
                  ),
                ),
              ),
            ],
          ),

          // Spacer to push button to bottom
          const Spacer(),

          // Button Section
          Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.03),
            child: MaterialButton(
              onPressed: () => onPressed(),
              color: const Color(0xFF10083F),
              minWidth: screenWidth * 0.9,
              height: screenHeight * 0.06,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Curve amount
              ),
              child: Text(buttonText, style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
