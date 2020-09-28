import 'package:flutter/material.dart';
import 'package:kuku/utils/constant.dart';

class PremiumContainer extends StatelessWidget {
  final child;
  const PremiumContainer({@required this.child, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height >= 775.0
          ? MediaQuery.of(context).size.height
          : 775.0,
      decoration: BoxDecoration(gradient: Constant.selectedGradient),
      child: child,
    );
  }
}
