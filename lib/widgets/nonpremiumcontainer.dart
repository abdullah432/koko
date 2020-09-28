import 'package:flutter/material.dart';
import 'package:kuku/utils/constant.dart';

class NonPremiumContainer extends StatelessWidget {
  final child;
  const NonPremiumContainer({@required this.child, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height >= 775.0
          ? MediaQuery.of(context).size.height
          : 775.0,
      color: Constant.selectedColor,
      child: child,
    );
  }
}
