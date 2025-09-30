import 'package:flutter/material.dart';

class FadeInTransition extends PageRouteBuilder {
  final Widget page;

  FadeInTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}