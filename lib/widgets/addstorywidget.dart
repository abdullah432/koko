import 'package:flutter/material.dart';

class AddStoryWidget extends StatelessWidget {
  const AddStoryWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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