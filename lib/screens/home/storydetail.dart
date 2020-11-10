import 'package:fluttertoast/fluttertoast.dart';
import 'package:kuku/screens/home/editstorypage.dart';
import 'package:kuku/screens/imageview.dart';
import 'package:kuku/utils/constant.dart';
import 'package:date_format/date_format.dart';
import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:kuku/model/Story.dart';
import 'package:kuku/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:kuku/utils/customfirestore.dart';
import 'package:kuku/widgets/imageslider.dart';
import 'package:kuku/widgets/listofuserphotos.dart';
import 'package:kuku/widgets/nonpremiumcontainer.dart';
import 'package:kuku/widgets/premiumcontainer.dart';

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

  //if user edit the story then on back we will update the home screen data
  bool editDone = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Stack(
          children: [
            //Full screen image
            Hero(
              tag: 'd',
              // tag: 'hero$currentIndex',
              child: ImageSlider(
                story: story,
              ),
              // Constant.primiumThemeSelected
              //     ? PremiumContainer(
              //         gradient: Constant.selectedGradient,
              //         child: SizedBox.expand(),
              //       )
              //     : NonPremiumContainer(
              //         color: Constant.selectedColor,
              //         child: SizedBox.expand(),
              //       ),
              // Container(
              //     color: Colors.black,
              //     child: SizedBox.expand(
              //       // child: FittedBox(
              //       //     fit: BoxFit.cover,
              //       //     child: Image(
              //       //       image: Constant.getImageAsset(story),
              //       //     )),
              //     )),
            ),
            //Draggable Scrollable sheet
            DraggableScrollableSheet(
              initialChildSize: 0.659,
              minChildSize: 0.650,
              builder: (context, controller) {
                return SingleChildScrollView(
                  controller: controller,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 30.0, bottom: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DATE',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Raleway',
                                fontSize: 19.0),
                          ),
                          //space
                          SizedBox(height: 10.0),
                          Text(
                            formatDate(Constant.getActiveStoryDate(story.date),
                                [dd, ' ', MM, ' ', yyyy]),
                            style: TextStyle(
                              // color: Colors.black,
                              // fontWeight: FontWeight.bold,
                              fontFamily: 'Raleway',
                              fontSize: 19,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'TITLE',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Raleway',
                                fontSize: 19.0),
                          ),
                          //space
                          SizedBox(height: 10.0),
                          Text(
                            story.title,
                            style: TextStyle(
                              color: Colors.black,
                              // fontWeight: FontWeight.bold,
                              fontFamily: 'Raleway',
                              fontSize: 19,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
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
                              fontSize: 19,
                            ),
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
                          story.note != null
                              ? Text(
                                  'YOUR DAILY NOTES',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Raleway',
                                      fontSize: 19.0),
                                )
                              : Container(height: 0.0),
                          //space
                          SizedBox(height: 10.0),
                          story.note != null
                              ? Text(
                                  story.note != ''
                                      ? story.note
                                      : 'You choose to not record it',
                                  style: TextStyle(
                                      // color: Colors.white,
                                      fontFamily: 'Raleway',
                                      fontSize: 19),
                                )
                              : Container(height: 0.0),
                          //Photos
                          story.images != null && story.images.length != 0
                              ? Text(
                                  'IMAGES OF THE DAY',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Raleway',
                                      fontSize: 19.0),
                                )
                              : Container(height: 0.0),
                          story.images != null && story.images.length != 0
                              ? ListOfUserPhotos(
                                  images: story.images,
                                  onTap: (index) {
                                    navigateToPhotoView(story.images, index);
                                  },
                                )
                              : Container(height: 0.0),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              right: 10,
              top: 30,
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(children: [
                    IconButton(
                      onPressed: () {
                        _showMyDialog();
                      },
                      icon: Icon(Icons.share, color: Colors.yellow, size: 30),
                    ),
                    IconButton(
                      onPressed: () {
                        navigateToEditStory();
                      },
                      icon: Icon(Icons.edit, color: Colors.yellow, size: 30),
                    ),
                  ])),
            ),
          ],
        ),
      ),
    );
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
    Story returnStory = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => EditStoryPage(story: story)));
    if (returnStory != null) {
      setState(() {
        story = returnStory;
        editDone = true;
      });
    }
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

  Future<bool> _onBackPressed() {
    if (editDone)
      Navigator.pop(context, story);
    else
      return Future.value(true);
  }

  //alert dialog
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Share Your Story'),
          content: Text('Are you sure you want to public your story'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Share'),
              onPressed: () async {
                if (story.whatHappened.length > 10) {
                  CustomFirestore customFirestore = CustomFirestore();
                  bool result = await customFirestore.shareUserPostToFireStore(
                      story: story);
                  if (result) {
                    Fluttertoast.showToast(msg: "Story shared successfully");
                  } else {
                    Fluttertoast.showToast(msg: "Unexpected Error occured");
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: "Story text must be greater than 10 characters");
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
