import 'package:kuku/screens/editstorypage.dart';
import 'package:kuku/utils/constant.dart';
import 'package:date_format/date_format.dart';
import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:kuku/model/Story.dart';
import 'package:kuku/utils/constant.dart';
import 'package:flutter/material.dart';

class StoryDetail extends StatefulWidget {
  final Story story;
  final int currentIndex;
  StoryDetail(this.story, this.currentIndex);

  @override
  State<StatefulWidget> createState() {
    return StoryDetailState(story, currentIndex);
  }
}

class StoryDetailState extends State<StoryDetail> {
  Story story;
  int currentIndex;
  StoryDetailState(this.story, this.currentIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        //Full screen image
        Hero(
          tag: 'd',
          // tag: 'hero$currentIndex',
          child: Container(
              color: Colors.black,
              child: SizedBox.expand(
                child: FittedBox(
                    fit: BoxFit.cover,
                    child: Image(
                      image: Constant.getImageAsset(story),
                    )),
              )),
        ),
        Positioned(
            right: 10,
            top: 30,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: IconButton(
                onPressed: () {
                  navigateToEditStory();
                },
                icon: Icon(Icons.edit, color: Colors.yellow, size: 30),
              ),
            )),
        //Draggable Scrollable sheet
        DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.45,
            builder: (context, controller) {
              return SingleChildScrollView(
                controller: controller,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 0.0, bottom: 15.0),
                      child: Text(
                        formatDate(Constant.getActiveStoryDate(story.date),
                            [dd, ' ', MM, ' ', yyyy]),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, bottom: 15.0),
                      child: Text(
                        story.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Raleway',
                            fontSize: 26),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 30.0, bottom: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //heading 1
                            Text(
                              'FEELING',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Raleway',
                                  fontSize: 19.0),
                            ),
                            //space
                            SizedBox(height: 10.0),
                            Text(
                              story.feeling,
                              style: TextStyle(
                                  // color: Colors.white,
                                  fontFamily: 'Raleway',
                                  fontSize: 19),
                            ),
                            //space
                            SizedBox(height: 20.0),
                            //heading 2
                            Text(
                              'REASON',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Raleway',
                                  fontSize: 19.0),
                            ),
                            //space
                            SizedBox(height: 10.0),
                            Text(
                              story.reason,
                              style: TextStyle(
                                  // color: Colors.white,
                                  fontFamily: 'Raleway',
                                  fontSize: 19),
                            ),
                            //space
                            SizedBox(height: 20.0),
                            //heading 3
                            Text(
                              'WHAT HAPPENED TODAY',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Raleway',
                                  fontSize: 19.0),
                            ),
                            //space
                            SizedBox(height: 10.0),
                            Text(
                              story.whatHappened != ''
                                  ? story.whatHappened
                                  : 'You choose to not record it',
                              style: TextStyle(
                                  // color: Colors.white,
                                  fontFamily: 'Raleway',
                                  fontSize: 19),
                            ),
                            //space
                            SizedBox(height: 20.0),
                            _facebookNativeBannerAd(),
                            //space
                            SizedBox(height: 20.0),
                            //heading 4
                            Text(
                              'YOUR DAILY NOTES',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Raleway',
                                  fontSize: 19.0),
                            ),
                            //space
                            SizedBox(height: 10.0),
                            Text(
                              story.note != ''
                                  ? story.note
                                  : 'You choose to not record it',
                              style: TextStyle(
                                  // color: Colors.white,
                                  fontFamily: 'Raleway',
                                  fontSize: 19),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
      ],
    ));
  }

  _facebookNativeBannerAd() {
    return FacebookNativeAd(
      placementId: "3663243730352300_3663623960314277",
      adType: NativeAdType.NATIVE_BANNER_AD,
      bannerAdSize: NativeBannerAdSize.HEIGHT_100,
      keepExpandedWhileLoading: false,
      width: double.infinity,
      height: 100.0,
      backgroundColor: Colors.blue,
      titleColor: Colors.white,
      descriptionColor: Colors.white,
      buttonColor: Colors.deepPurple,
      buttonTitleColor: Colors.white,
      buttonBorderColor: Colors.white,
      listener: (result, value) {
        print("Native Ad: $result --> $value");
      },
    );
  }

  navigateToEditStory() async {
    story = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => EditStoryPage(story: story)));
    setState(() {
      print('data updated');
    });
  }
}
