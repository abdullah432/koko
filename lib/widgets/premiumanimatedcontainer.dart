import 'package:flutter/material.dart';
import 'package:kuku/utils/constant.dart';

class PremiumAnimatedContainer extends StatelessWidget {
  final height;
  final width;
  final child;
  const PremiumAnimatedContainer(
      {@required this.height, @required this.width, @required this.child, Key key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOutQuint,
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: Constant.selectedGradient,
      ),
      child: child
    );
  }
}
