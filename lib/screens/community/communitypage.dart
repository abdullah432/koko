import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kuku/model/Post.dart';
import 'package:kuku/model/Story.dart';
import 'package:kuku/screens/community/commentspage.dart';
import 'package:kuku/screens/community/communitystorydetail.dart';
import 'package:kuku/utils/GlobalData.dart';
import 'package:kuku/utils/constant.dart';
import 'package:kuku/utils/customfirestore.dart';
import 'package:kuku/utils/navigation.dart';
import 'package:kuku/widgets/likeAndcommentRow.dart';
import 'package:kuku/widgets/photoGridView.dart';

class CommunityPage extends StatefulWidget {
  CommunityPage({Key key}) : super(key: key);

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  List<Post> listOfStories;
  //when data is loading we will show progress animation
  bool storiesloading = true;
  //storage
  CustomFirestore customFirestore = CustomFirestore();

  @override
  void initState() {
    loadPublicStoriesData();
    super.initState();
  }

  loadPublicStoriesData() async {
    if (GlobalData.publicStoryList == null) {
      //load data
      GlobalData.publicStoryList =
          await customFirestore.loadPublicStoriesData();
      listOfStories = GlobalData.publicStoryList;
    } else {
      listOfStories = GlobalData.publicStoryList;
    }
    setState(() {
      storiesloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (storiesloading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Constant.selectedColor),
      ));
    } else {
      return mainBody();
    }
    // return StreamBuilder(
    //   stream: FirebaseFirestore.instance.collection('posts').doc().snapshots(),
    //   builder: (context, snapshot) {
    //     if (!snapshot.hasData)
    //       return Center(child: CircularProgressIndicator());
    //     final int cardLength = snapshot.data.documents.length;
    //     return mainbody();
    //   },
    // );
  }

  mainBody() {
    return listOfStories.length != 0
        ? ListView.builder(
            // Let the ListView know how many items it needs to build.
            itemCount: listOfStories.length,
            // Provide a builder function. This is where the magic happens.
            // Convert each item into a widget based on the type of item it is.
            itemBuilder: (context, index) {
              final publicstory = listOfStories[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Constant.communitystorybgcolor,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        //title and feeling
                        titleANDfeelingRow(publicstory),
                        //space
                        SizedBox(height: 10.0),
                        //story text
                        storyTextDetailWidget(publicstory),
                        //read more
                        readMoreButton(publicstory),
                        //  Text('${story.whatHappened}')),
                        //space
                        SizedBox(height: 10.0),
                        //photos gridview
                        publicstory.images != null
                            ? photosGridView(publicstory.images)
                            : Container(
                                height: 0.0,
                              ),
                        //space
                        SizedBox(height: 10.0),
                        //reaction section widget
                        ReactionSectionWidget(
                          onLikeClick: (likeStatus) =>
                              _onLikeClick(likeStatus, publicstory),
                          onCommentClick: () => Navigation.navigateTo(
                            context,
                            CommunityCommentPage(),
                          ),
                          publicstory: publicstory,
                          customFirestore: customFirestore,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        : Center(
            child: Text('Be the first to share your story with the world'),
          );
  }

  titleANDfeelingRow(story) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          story.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        getCurrentStoryIcon(story),
      ],
    );
  }

  storyTextDetailWidget(story) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: story.whatHappened.length > 90 ? 140 : null,
        child: Text(
          story.whatHappened,
          overflow: TextOverflow.fade,
          style: TextStyle(fontSize: 17.0),
        ),
      ),
    );
  }

  readMoreButton(story) {
    return story.whatHappened.length > 90
        ? Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                Navigation.navigateTo(
                    context, CommunityStoryDetail(story: story));
              },
              child: Text(
                'read more',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          )
        : Container(
            height: 0.0,
          );
  }

  photosGridView(images) {
    return PhotoGridView(
      images: images,
      onTap: (index) => Navigation.navigateToPhotoView(
          context: context, images: images, index: index),
    );
  }

  getCurrentStoryIcon(story) {
    if (story.feeling == 'HAPPY')
      return Icon(
        FlutterIcons.smile_faw5,
        color: Colors.green,
      );
    else if (story.feeling == 'COMPLETELY OK' ||
        story.feeling == 'COMPLETLY OK')
      return Icon(FlutterIcons.meh_faw5);
    else
      return Icon(FlutterIcons.angry_faw5, color: Colors.red);
  }

  //logic
  _onLikeClick(likeStatus, Post publicStory) {
    customFirestore.updateLikeState(likedState: likeStatus, postid: publicStory.postid);
    if (likeStatus) {
      //add like
      setState(() {
        publicStory.totallikes++;
      });
    } else {
      //remove like
      setState(() {
        publicStory.totallikes--;
      });
    }
  }
}
