import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kuku/model/Post.dart';
import 'package:kuku/utils/constant.dart';
import 'package:kuku/utils/customfirestore.dart';

class ReactionSectionWidget extends StatelessWidget {
  final Post publicstory;
  final CustomFirestore customFirestore;
  final isPostLiked;
  final void Function(bool status) onLikeClick;
  final void Function() onCommentClick;
  const ReactionSectionWidget({
    @required this.publicstory,
    @required this.customFirestore,
    @required this.onLikeClick,
    @required this.onCommentClick,
    @required this.isPostLiked,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        publicstory.totallikes != 0
            ? Text('${publicstory.totallikes}',
                style: TextStyle(fontWeight: FontWeight.bold))
            : Container(
                width: 14.0,
              ),
        SizedBox(width: 5.0),
        getLikeIcon(),
        SizedBox(width: 35.0),
        Text('10', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 5.0),
        GestureDetector(
            onTap: () => onCommentClick(),
            child: Text('comments',
                style: TextStyle(fontWeight: FontWeight.bold))),
      ],
    );
  }

  getLikeIcon() {
    if (isPostLiked) {
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
