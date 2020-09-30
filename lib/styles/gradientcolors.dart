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

  //
  static const gradientbutton1 = const LinearGradient(
      colors: [GradientColors.gradient1End, GradientColors.gradient1Start],
      begin: const FractionalOffset(0.2, 0.2),
      end: const FractionalOffset(1.0, 1.0),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp);

  //list of gradient start color
  static List<Color> listOfGradientStartColor = [gradient1Start];
}
