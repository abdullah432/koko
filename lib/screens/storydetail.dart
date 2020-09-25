import 'dart:async';
import 'dart:io';
import 'package:kuku/utils/constant.dart';
import 'package:date_format/date_format.dart';
import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
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

  // native ad
  static const _adUnitID = "ca-app-pub-5554760537482883/4297761131";

  final _nativeAdController = NativeAdmobController();
  double _height = 0;

  StreamSubscription _subscription;

  // //for facebook native ad
  // Widget _currentAd = SizedBox(
  //   width: 0.0,
  //   height: 0.0,
  // );

  @override
  void initState() {
    _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _nativeAdController.dispose();
    super.dispose();
  }

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          _height = 0;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          _height = 330;
        });
        break;

      default:
        break;
    }
  }
  //native ad

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
                          left: 15.0, right: 15.0, top: 60.0, bottom: 15.0),
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
                      // height: double.maxFinite,
                      // color: Colors.white,
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
                            //space
                            SizedBox(height: 10.0),
                            Constant.facebooknative
                                ? _facebookNativeAd()
                                : _admobNativeAd(),
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

  _admobNativeAd() {
    return Container(
      height: _height,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 20.0),
      child: NativeAdmob(
        // Your ad unit id
        adUnitID: _adUnitID,
        controller: _nativeAdController,
        // Don't show loading widget when in loading state
        loading: Container(),
      ),
    );
  }

  _facebookNativeAd() {
    return FacebookNativeAd(
      placementId: "3663243730352300_3663359137007426",
      adType: NativeAdType.NATIVE_AD,
      width: double.infinity,
      height: 300,
      backgroundColor: Colors.blue,
      titleColor: Colors.white,
      descriptionColor: Colors.white,
      buttonColor: Colors.deepPurple,
      buttonTitleColor: Colors.white,
      buttonBorderColor: Colors.white,
      keepAlive:
          true, //set true if you do not want adview to refresh on widget rebuild
      keepExpandedWhileLoading:
          false, // set false if you want to collapse the native ad view when the ad is loading
      expandAnimationDuraion:
          300, //in milliseconds. Expands the adview with animation when ad is loaded
      listener: (result, value) {
        print("Native Ad: $result --> $value");
      },
    );
  }
}
