import 'package:flutter/material.dart';

class FadeScaleTransition extends StatelessWidget {
  const FadeScaleTransition({super.key, required this.controller, required this.child});

  final AnimationController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(parent: controller, curve: Curves.easeOutExpo);
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.9, end: 1).animate(animation),
        child: child,
      ),
    );
  }
}
