import 'package:flutter/material.dart';
import 'package:kuku/utils/constant.dart';

class NonPremiumContainer extends StatelessWidget {
  final child;
  Color color;
  NonPremiumContainer({@required this.child, @required this.color, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height >= 775.0
          ? MediaQuery.of(context).size.height
          : 775.0,
      color: color,
      child: child,
    );
  }
}
