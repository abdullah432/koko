import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kuku/model/Story.dart';
import 'package:kuku/utils/GlobalData.dart';
import 'package:kuku/utils/constant.dart';
import 'package:kuku/widgets/likeAndcommentRow.dart';

import '../imageview.dart';

class CommunityPage extends StatefulWidget {
  CommunityPage({Key key}) : super(key: key);

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  List<Story> listOfStories = GlobalData.storyList;
  @override
  Widget build(BuildContext context) {
    return listOfStories.length != 0
        ? ListView.builder(
            // Let the ListView know how many items it needs to build.
            itemCount: listOfStories.length,
            // Provide a builder function. This is where the magic happens.
            // Convert each item into a widget based on the type of item it is.
            itemBuilder: (context, index) {
              final story = listOfStories[index];
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
                        titleANDfeelingRow(story),
                        //space
                        SizedBox(height: 10.0),
                        //story text
                        storyTextDetailWidget(story),
                        //read more
                        readMoreButton(story.whatHappened.length),
                        //  Text('${story.whatHappened}')),
                        //space
                        SizedBox(height: 10.0),
                        //photos gridview
                        story.images != null
                            ? photosGridView(story.images)
                            : Container(
                                height: 0.0,
                              ),
                        //space
                        SizedBox(height: 10.0),
                        //reaction section widget
                        ReactionSectionWidget(
                          onLikeClick: (value) => _onLikeClick(value, story),
                          story: story,
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

  titleANDfeelingRow(Story story) {
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

  storyTextDetailWidget(Story story) {
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

  readMoreButton(textlength) {
    return textlength > 90
        ? Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {},
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
    return images.length != 0
        ? GridView.count(
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 15.0,
            mainAxisSpacing: 15.0,
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            crossAxisCount: images.length > 1 ? 2 : 1,
            shrinkWrap: true,
            children: List.generate(images.length, (index) {
              return GestureDetector(
                onTap: () {
                  navigateToPhotoView(images, index);
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: images[index],
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Container(
                              // height: 200,
                              // width: 120,
                              child: Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress),
                      )),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )),
              );
            }),
          )
        : Container(height: 0.0);
  }

  navigateToPhotoView(images, index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyPhotoView(
                  galleryItems: images,
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  initialIndex: index,
                  scrollDirection: Axis.horizontal,
                )));
  }

  getCurrentStoryIcon(Story story) {
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
  _onLikeClick(value, Story story) {
    if (value) {
      //add like
      setState(() {
        story.likes.add(Constant.useruid);
      });
    } else {
      //remove like
      setState(() {
        story.likes.remove(Constant.useruid);
      });
    }
  }
}
