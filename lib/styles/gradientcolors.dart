import 'package:flutter/material.dart';

class GradientColors {
  const GradientColors();

  static const Color gradient1Start = const Color(0xFFfbab66);
  static const Color gradient1End = const Color(0xFFf7418c);

  static const Color gradient2Start = const Color(0xFF2395B8);
  static const Color gradient2End = const Color(0xffADDEAF);

  static const Color gradient3Start = const Color(0xFFCEABD1);
  static const Color gradient3End = const Color(0xffFDE2E0);

  static const Color gradient4Start = const Color(0xFFEB8F7B);
  static const Color gradient4End = const Color(0xffFAD3A5);

  static const Color gradient5Start = const Color(0xFFE70E05);
  static const Color gradient5End = const Color(0xffFBCD18);

  static const Color gradient6Start = const Color(0xFF093366);
  static const Color gradient6End = const Color(0xff61B29F);

  static const gradient1 = const LinearGradient(
    colors: const [gradient1Start, gradient1End],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const gradient2 = const LinearGradient(
    colors: const [gradient2Start, gradient2End],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const gradient3 = const LinearGradient(
    colors: const [gradient3Start, gradient3End],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const gradient4 = const LinearGradient(
    colors: const [gradient4Start, gradient4End],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const gradient5 = const LinearGradient(
    colors: const [gradient5Start, gradient5End],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const gradient6 = const LinearGradient(
    colors: const [gradient6Start, gradient6End],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  //gradient button styles
  static const gradientbutton1 = const LinearGradient(
      colors: [GradientColors.gradient1End, GradientColors.gradient1Start],
      begin: const FractionalOffset(0.2, 0.2),
      end: const FractionalOffset(1.0, 1.0),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp);

  static const gradientbutton2 = const LinearGradient(
      colors: [GradientColors.gradient2End, GradientColors.gradient2Start],
      begin: const FractionalOffset(0.2, 0.2),
      end: const FractionalOffset(1.0, 1.0),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp);

  static const gradientbutton3 = const LinearGradient(
      colors: [GradientColors.gradient3End, GradientColors.gradient3Start],
      begin: const FractionalOffset(0.2, 0.2),
      end: const FractionalOffset(1.0, 1.0),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp);

  static const gradientbutton4 = const LinearGradient(
      colors: [GradientColors.gradient4End, GradientColors.gradient4Start],
      begin: const FractionalOffset(0.2, 0.2),
      end: const FractionalOffset(1.0, 1.0),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp);

  static const gradientbutton5 = const LinearGradient(
      colors: [GradientColors.gradient5End, GradientColors.gradient5Start],
      begin: const FractionalOffset(0.2, 0.2),
      end: const FractionalOffset(1.0, 1.0),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp);

  static const gradientbutton6 = const LinearGradient(
      colors: [GradientColors.gradient6End, GradientColors.gradient6Start],
      begin: const FractionalOffset(0.2, 0.2),
      end: const FractionalOffset(1.0, 1.0),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp);

  //list of gradient start color (for appbar)
  static List<Color> listOfGradientStartColor = [
    gradient1Start,
    gradient2Start,
    gradient3Start,
    gradient4Start,
    gradient5Start,
    gradient6Start,
  ];
}
