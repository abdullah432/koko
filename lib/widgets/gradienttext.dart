import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  GradientText({
    @required this.text,
    @required this.gradient,
    @required this.size,
  });

  final String text;
  final Gradient gradient;
  final size;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: TextStyle(
          // The color must be set to white for this to work
          color: Colors.white,
          fontSize: size,
        ),
      ),
    );
  }
}
