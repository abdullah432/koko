import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kuku/model/Story.dart';
import 'package:kuku/utils/constant.dart';

class ReactionSectionWidget extends StatelessWidget {
  final Story story;
  final void Function(bool status) onLikeClick;
  const ReactionSectionWidget({
    @required this.story,
    @required this.onLikeClick,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        story.likes.length != 0
            ? Text('${story.likes.length}',
                style: TextStyle(fontWeight: FontWeight.bold))
            : Container(
                width: 14.0,
              ),
        SizedBox(width: 5.0),
        getLikeIcon(story.likes),
        SizedBox(width: 35.0),
        Text('10', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 5.0),
        Text('comments', style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  getLikeIcon(List<String> likes) {
    if (likes.contains(Constant.useruid)) {
      return GestureDetector(
          onTap: () => onLikeClick(false),
          child: Icon(
            FlutterIcons.heart_faw,
            color: Colors.redAccent,
          ));
    } else {
      return GestureDetector(
          onTap: () => onLikeClick(true),
          child: Icon(
            FlutterIcons.heart_faw5,
            color: Colors.black45,
          ));
    }
  }
}
