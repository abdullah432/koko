import 'package:flutter/material.dart';
import 'package:kuku/utils/constant.dart';

class PremiumButton extends StatelessWidget {
  // final GestureTapCallback onTap;
  final void Function(BuildContext) onTap;
  final String text;
  const PremiumButton({@required this.onTap, @required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: text == 'LOGIN' ? 190.0 : 270.0),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            offset: Offset(1.0, 6.0),
            blurRadius: 20.0,
          ),
        ],
        gradient: Constant.selectedButtonGradient,
      ),
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
        onPressed: () => this.onTap(context),
      ),
    );
  }
}
