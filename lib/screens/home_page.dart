import 'dart:async';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kuku/model/Story.dart';
import 'package:kuku/screens/add_story.dart';
import 'package:kuku/screens/settings/settingpage.dart';
import 'package:kuku/screens/storydetail.dart';
import 'package:kuku/utils/constant.dart';
import 'package:kuku/utils/customfirestore.dart';
import 'package:flutter/material.dart';
import 'package:kuku/utils/mycustomadmob.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:kuku/widgets/dropdownpopup.dart';

class HomePage extends StatefulWidget {
  final bool storyAdded;
  HomePage({this.storyAdded});
  @override
  State<StatefulWidget> createState() {
    return HomePageState(storyAdded);
  }
}

class HomePageState extends State<HomePage> {
  //when home page call after adding new story then we will move to end of pages
  bool storyAdded;
  HomePageState(this.storyAdded);

  final PageController pageController = PageController(viewportFraction: 0.8);
  int currentPage = 0;
  int count = 0;
  CustomFirestore _customFirestore = CustomFirestore();
  List<Story> storyList;

  double height;
  double width;
  bool buttonDown = false;

  //snackbar
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //when user reach to end then this will be true
  bool reachToEnd = false;
  //admob
  MyCustomAdmob myCustomAdmob = MyCustomAdmob();

  @override
  void initState() {
    _customFirestore.loadUserName(userid: Constant.useruid);
    super.initState();

    pageController.addListener(() {
      int next = pageController.page.round();
      if (currentPage != next) {
        setState(() {
          currentPage = next;
          print(pageController.page.toString());
          print(count.toString());
          //when count is zero then do nothing
          if (count != 0) {
            if (pageController.page > (count)) {
              reachToEnd = true;
            } else {
              reachToEnd = false;
            }
          }
        });
      }
    });

    // //if homepage call from addstory page then move to last page
    if (storyAdded != null) {
      if (Constant.videoAd) {
        showInterstitialVideoAd();
        Constant.videoAd = false;
      } else {
        showInterstitialAd();
        Constant.videoAd = true;
      }

      Timer(Duration(seconds: 1), () => moveToEndOfPage());
    }
  }

  showInterstitialAd() {
    myCustomAdmob.interstitialAdMob()
      ..load()
      ..show();
  }

  showInterstitialVideoAd() {
    myCustomAdmob.interstitialVideoAdMob()
      ..load()
      ..show();
  }

  showFacebookInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "3663243730352300_3663613440315329",
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED)
          FacebookInterstitialAd.showInterstitialAd(delay: 5000);
        if (result == InterstitialAdResult.ERROR) showInterstitialVideoAd();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (storyList == null) {
      storyList = new List<Story>();
      updateStoryList();
    }

    return Scaffold(
        key: _scaffoldKey,
        body: Stack(children: [
          //PageView
          PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: pageController,
              itemCount: count + 2,
              itemBuilder: (BuildContext context, int currentIndex) {
                if (currentIndex == 0) {
                  return introductryPage();
                } else if (currentIndex == 1) {
                  // debugPrint(currentPage.toString());
                  bool active = currentIndex == currentPage;
                  return addNotePage(active);
                } else if (storyList.length + 1 >= currentIndex) {
                  // debugPrint('StoryList Length' + storyList.length.toString());
                  // debugPrint('currentIndex 1:' + currentIndex.toString());
                  bool active = currentIndex == currentPage;
                  // debugPrint('currentIndex 2:' + currentIndex.toString());
                  return storyPages(
                      storyList[currentIndex - 2], active, currentIndex);
                }
              }),
          //setting button
          Positioned(
              top: 35.0,
              right: 12.0,
              child: GestureDetector(
                onTap: () {
                  navigateToSettingPage();
                },
                child: CustomDropDownPopup(),
                // Icon(
                //   Icons.settings,
                //   color: Constant.selectedColor,
                //   size: 30,
                // ),
              )),
          //setting button
          Positioned(
              bottom: 35.0,
              right: 12.0,
              child: GestureDetector(
                onTap: () {
                  // print(pageController.page.toString());
                  setState(() {
                    if (!reachToEnd) {
                      moveToEndOfPage();
                      reachToEnd = true;
                    } else {
                      moveToFirstPage();
                      reachToEnd = false;
                    }
                  });
                },
                child: reachToEnd
                    ? Icon(
                        FlutterIcons.backward_faw,
                        color: Constant.selectedColor,
                        size: 30,
                      )
                    : Icon(
                        FlutterIcons.forward_faw5s,
                        color: Constant.selectedColor,
                        size: 30,
                      ),
              )),
        ]));
  }

  Widget storyPages(Story storyList, bool active, currentIndex) {
    height = active ? 380 : 350;
    width = active ? 300 : 250;
    return Center(
        child: GestureDetector(
            onTap: () {
              navigateToStoryDetailPage(storyList, currentIndex);
            },
            child: Hero(
              tag: 'hero$currentIndex',
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOutQuint,
                height: height,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Constant.getImageAsset(storyList),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(top: 15.0, left: 15.0),
                              child: Container(
                                width: 80,
                                child: Text(
                                  formatDate(
                                      Constant.getActiveStoryDate(
                                          storyList.date),
                                      [dd, ' ', MM, ' ', yyyy]),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              )),
                          FlatButton(
                            onPressed: () {
                              showDeleteAlert(storyList);
                            },
                            child: Icon(
                              Icons.delete,
                              size: 30,
                              color: Colors.white,
                            ),
                          )
                        ]),
                    Padding(
                      padding: EdgeInsets.only(bottom: 40, left: 20),
                      child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            getActiveStoryTitle(storyList),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )),
                    )
                  ],
                ),
              ),
            )));
  }

  Widget introductryPage() {
    return InkWell(
        onTap: () {
          pageController.animateToPage(currentPage + 1,
              curve: Curves.easeOutQuint,
              duration: Duration(microseconds: 1000));
        },
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Your',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 40,
                  color: Colors.black,
                ),
              ),
              Text(
                'Stories',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 40,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ));
  }

  Widget addNotePage(bool active) {
    // final double h = active ? 390 : 370;
    // final double w = active ? 300 : 240;
    if (!buttonDown) {
      height = active ? 380 : 350;
      width = active ? 300 : 250;
    }

    return Center(
        child: GestureDetector(
            onTapDown: (TapDownDetails details) => addNewStoryBtnClick(),
            onTap: () {
              setState(() {
                height = 370;
                width = 282;
                buttonDown = true;
              });
              navigateToAddStory();
            },
            onTapUp: (TapUpDetails details) => addNoteButtonUp(),
            onTapCancel: () {
              setState(() {
                buttonDown = false;
              });
            },
            child: Hero(
              tag: 'addstory',
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOutQuint,
                height: height,
                width: width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Constant.selectedColor),
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
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Raleway'),
                    ),
                  ],
                ),
              ),
            )));
  }

  void addNewStoryBtnClick() {
    setState(() {
      height = 350;
      width = 282;
      buttonDown = true;
    });
  }

  addNoteButtonUp() {
    setState(() {
      buttonDown = false;
    });
  }

  void navigateToAddStory() async {
    // await new Future.delayed(const Duration(milliseconds: 30));
    // Route route = ScaleRoute(page: AddStory());
    // Navigator.push(context, route);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddStory()));
  }

  navigateToSettingPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingPage()));
  }

  String getActiveStoryTitle(Story storyList) {
    return storyList.title;
  }

  void deleteActiveStory(Story story) async {
    bool response = await _customFirestore.deleteStory(story.date);
    if (response == true) {
      setState(() {
        storyList.remove(story);
      });
    } else {
      showSnackBar('Failed to delete');
    }
  }

  void showSnackBar(msg) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(msg)));
  }

  void updateStoryList() async {
    this.storyList = await _customFirestore.loadStoriesData();
    if (this.mounted) {
      setState(() {
        this.count = storyList.length;
      });
    }
  }

  void showDeleteAlert(Story story) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Delete'),
            content: Text("Are You sure you want to delete this story"),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  deleteActiveStory(story);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  //methods
  void moveToEndOfPage() {
    pageController.animateToPage(
      count + 1,
      curve: Curves.easeIn,
      duration: Duration(milliseconds: 700),
    );
  }

  void moveToFirstPage() {
    pageController.animateToPage(
      0,
      curve: Curves.easeIn,
      duration: Duration(milliseconds: 700),
    );
  }

  navigateToStoryDetailPage(storyList, currentIndex) {
    //this will once load facebook ads and once admob ads
    if (Constant.facebooknative)
      Constant.facebooknative = false;
    else
      Constant.facebooknative = true;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StoryDetail(storyList, currentIndex)));
  }
}
