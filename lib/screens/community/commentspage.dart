import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jiffy/jiffy.dart';
import 'package:kuku/model/comment.dart';

class CommunityCommentPage extends StatefulWidget {
  CommunityCommentPage({Key key}) : super(key: key);

  @override
  _CommunityCommentPageState createState() => _CommunityCommentPageState();
}

class _CommunityCommentPageState extends State<CommunityCommentPage> {
  List<Comment> listOfComment = [
    Comment(
      username: 'Abdullah khan',
      dateTime: DateTime(2020, 11, 9, 22, 40, 23),
      message: 'Oh no',
    ),
    Comment(
      username: 'Luqman Hafeez',
      dateTime: DateTime(2020, 11, 9, 23, 20, 23),
      message: 'So sorry',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'COMMENTS',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            FlutterIcons.ios_arrow_round_back_ion,
            color: Colors.black,
            size: 40,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        itemCount: listOfComment.length,
        itemBuilder: (context, index) {
          Comment comment = listOfComment[index];
          return ListTile(
            title: Row(children: [
              Text(comment.username, style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(width: 10.0),
              Text(Jiffy(comment.dateTime).fromNow(), style: TextStyle(color: Colors.black54,)),
            ]),
            subtitle: Text(comment.message),
          );
        },
      ),
    );
  }
}
