import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class GlassBox extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;

  const GlassBox({
    super.key,
    required this.child,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: width,
      height: height,
      borderRadius: 20,
      blur: 15,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.5), Colors.white.withOpacity(0.1)],
      ),
      child: child,
    );
  }
}
