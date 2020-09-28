import 'package:flutter/material.dart';
import 'package:kuku/utils/constant.dart';

class NonPremiumButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final String text;
  const NonPremiumButton({@required this.onTap, @required this.text, Key key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 190.0),
      color: Constant.selectedColor,
      child: MaterialButton(
        highlightColor: Colors.transparent,
        splashColor: const Color(0xFFf7418c),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
            ),
          ),
        ),
        onPressed: () => onTap,
      ),
    );
  }
}
