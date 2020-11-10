import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kuku/model/Story.dart';
import 'package:kuku/utils/navigation.dart';
import 'package:kuku/widgets/photoGridView.dart';

class CommunityStoryDetail extends StatefulWidget {
  Story story;
  CommunityStoryDetail({@required this.story, Key key}) : super(key: key);

  @override
  _CommunityStoryDetailState createState() => _CommunityStoryDetailState(story);
}

class _CommunityStoryDetailState extends State<CommunityStoryDetail> {
  Story story;
  _CommunityStoryDetailState(this.story);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            FlutterIcons.ios_arrow_round_back_ion,
            color: Colors.black,
            size: 40,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: 
      Stack(
        children: [
          //main view
          SingleChildScrollView(
            child: Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 21.0),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      story.whatHappened,
                      style: TextStyle(fontSize: 18.0, color: Colors.black87),
                    ),
                    SizedBox(height: 20.0),
                    PhotoGridView(
                      images: story.images,
                      onTap: (index) => Navigation.navigateToPhotoView(
                          context: context, images: story.images, index: index),
                    ),
                     SizedBox(height: 200.0),
                  ],
                ),
              ),
          ),
          //possitioned view
          Positioned(
            bottom: 20.0,
            left: 20.0,
            child: Row(
              children: [
                //like button
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 1,
                        blurRadius: 9,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      FlutterIcons.heart_faw5,
                      color: Colors.black45,
                    ),
                  ),
                ),
                //space
                SizedBox(width: 10.0),
                //comment button
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 1,
                        blurRadius: 9,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      FlutterIcons.comment_faw5,
                      color: Colors.black45,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
