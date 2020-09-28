import 'package:flutter/material.dart';
import 'package:kuku/utils/constant.dart';

class PremiumAnimatedContainer extends StatelessWidget {
  final height;
  final width;
  const PremiumAnimatedContainer(
      {@required this.height, @required this.width, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOutQuint,
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: Constant.selectedGradient,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.add, color: Colors.white, size: 80),
          Container(
            height: 15,
          ),
          Text(
            "ADD TODAY'S STORY",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: 'Raleway'),
          ),
        ],
      ),
    );
  }
}
