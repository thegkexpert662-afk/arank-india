import 'package:flutter/material.dart';

class AppAnimations {
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration normal = Duration(milliseconds: 280);
  static const Duration slow = Duration(milliseconds: 450);

  // Slide + Fade
  static Widget slideFade(
      Widget child,
      Animation<double> animation,
      ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.25, 0),
        end: Offset.zero,
      ).animate(animation),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  // Zoom
  static Widget scale(
      Widget child,
      Animation<double> animation,
      ) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }

  // Fade
  static Widget fade(
      Widget child,
      Animation<double> animation,
      ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  // Rotation
  static Widget rotation(
      Widget child,
      Animation<double> animation,
      ) {
    return RotationTransition(
      turns: animation,
      child: child,
    );
  }
}