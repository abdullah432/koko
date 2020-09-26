import 'package:flutter/material.dart';

class GradientColors {
  const GradientColors();

  static const Color gradient1Start = const Color(0xFFfbab66);
  static const Color gradient1End = const Color(0xFFf7418c);

  static const gradient1 = const LinearGradient(
    colors: const [gradient1Start, gradient1End],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
