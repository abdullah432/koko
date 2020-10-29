import 'package:flutter/material.dart';

class IconShadow extends StatelessWidget {
  final IconData icon;
  const IconShadow({@required this.icon, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
          BoxShadow(
            color: Colors.black45.withOpacity(.1),
            blurRadius: 5.0,
          ),
        ]),
        child:  Icon(
            icon,
            color: Colors.white,
            // size: 15,
          ),
        );
  }
}
