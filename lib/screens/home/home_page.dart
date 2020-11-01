import 'dart:async';
import 'package:date_format/date_format.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kuku/model/Story.dart';
import 'package:kuku/screens/addstory/add_story.dart';
import 'package:kuku/screens/settings/settingpage.dart';
import 'package:kuku/screens/home/storydetail.dart';
import 'package:kuku/utils/GlobalData.dart';
import 'package:kuku/utils/constant.dart';
import 'package:kuku/utils/customfirestore.dart';
import 'package:flutter/material.dart';
import 'package:kuku/widgets/addstorywidget.dart';
import 'package:kuku/widgets/gradienticons.dart';
import 'package:kuku/widgets/nonpremiumanimatedcontainer.dart';
import 'package:kuku/widgets/premiumanimatedcontainer.dart';
import 'package:kuku/widgets/dropdownpopup.dart';

class HomePage extends StatefulWidget {
  final bool storyAdded;
  HomePage({
    this.storyAdded,
    Key key,
  }) : super(key: key);
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

  double height;
  double width;
  bool buttonDown = false;

  //snackbar
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //when user reach to end then this will be true
  bool reachToEnd = false;
  //facebook ad widget
  bool facebookNativeAdLoaded = false;

  @override
  void initState() {
    //after calling page, count will be zero so
    if (GlobalData.storyList != null) count = GlobalData.storyList.length;
    super.initState();
    //now load user name and setting (one time per app use)
    if (!Constant.userDataLoaded) {
      _customFirestore.loadUserName(userid: Constant.useruid);
      _customFirestore.loadUserSetting(uid: Constant.useruid);
      //update userDataLoaded value
      Constant.userDataLoaded = true;
    }

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
      Timer(Duration(seconds: 1), () => moveToEndOfPage(count + 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (GlobalData.storyList == null) {
      GlobalData.storyList = new List<Story>();
      updateStoryList();
    }

    return Scaffold(
        key: _scaffoldKey,
        body: Stack(children: [
          //PageView
          PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: pageController,
              itemCount: count >= 3 ? count + 2 : count + 1,
              itemBuilder: (BuildContext context, int currentIndex) {
                if (currentIndex == 0) {
                  return introductryPage();
                } 
                // else if (currentIndex == 1) {
                //   // debugPrint(currentPage.toString());
                //   bool active = currentIndex == currentPage;
                //   return addNotePage(active);
                // } 
                else if (GlobalData.storyList.length + 1 == currentIndex) {
                  bool active = currentIndex == currentPage;
                  return nativeStoryAd(active);
                } else if (GlobalData.storyList.length >= currentIndex) {
                  bool active = currentIndex == currentPage;
                  return storyPages(
                    GlobalData.storyList[currentIndex - 1],
                    active,
                    currentIndex,
                  );
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
              )),
          //backward/forward button
          Positioned(
            bottom: 20.0,
            right: 12.0,
            child: GestureDetector(
              onTap: () {
                // print(pageController.page.toString());
                setState(() {
                  if (!reachToEnd) {
                    moveToEndOfPage(count + 2);
                    reachToEnd = true;
                  } else {
                    moveToFirstPage();
                    reachToEnd = false;
                  }
                });
              },
              child: reachToEnd
                  ? (Constant.primiumThemeSelected
                      ? GradientIcon(
                          icon: FlutterIcons.backward_faw,
                          size: 30,
                          gradient: Constant.selectedButtonGradient,
                        )
                      : Icon(
                          FlutterIcons.backward_faw,
                          color: Constant.selectedColor,
                          size: 30,
                        ))
                  : (Constant.primiumThemeSelected
                      ? GradientIcon(
                          icon: FlutterIcons.forward_faw5s,
                          size: 30,
                          gradient: Constant.selectedButtonGradient,
                        )
                      : Icon(
                          FlutterIcons.forward_faw5s,
                          color: Constant.selectedColor,
                          size: 30,
                        )),
            ),
          ),
        ]));
  }

  Widget storyPages(Story story, bool active, currentIndex) {
    height = active ? 330 : 290;
    width = active ? 275 : 250;
    return Center(
        child: GestureDetector(
            onTap: () {
              navigateToStoryDetailPage(story, currentIndex);
            },
            child: Hero(
              tag: 'hero$currentIndex',
              child: Constant.primiumThemeSelected
                  ? PremiumAnimatedContainer(
                      height: height,
                      width: width,
                      child: storyContainer(story: story),
                    )
                  : NonPremiumAnimatedContainer(
                      height: height,
                      width: width,
                      child: storyContainer(story: story),
                    ),
            )));
  }

  Widget storyContainer({@required Story story}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: Constant.getImageAsset(story),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            top: 25.0, left: 15.0, right: 15.0, bottom: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // SizedBox(height: 10),
            //first row
            dateAndDeleteBtnWidget(story),
            // //body text
            // Expanded(
            //   child: Align(
            //     alignment: Alignment.topLeft,
            //     child: Padding(
            //       padding: const EdgeInsets.only(top: 12.0),
            //       child: Text(
            //         '${story.whatHappened}',
            //         style: TextStyle(
            //           fontSize: 17,
            //           color: Colors.white,
            //         ),
            //         maxLines: 10,
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //     ),
            //   ),
            // ),
            //title at bottom
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    getActiveStoryTitle(story),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  dateAndDeleteBtnWidget(story) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            // width: 160,
            child: Text(
              formatDate(Constant.getActiveStoryDate(story.date),
                  [dd, ' ', M, ' ', yyyy]),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () {
                showDeleteAlert(story);
              },
              // FlatButton(
              //   onPressed: () {
              //     showDeleteAlert(story);
              //   },
              child: Icon(
                Icons.delete,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ]);
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

  Widget nativeStoryAd(bool active) {
    // height = active ? 380 : 350;
    // width = active ? 300 : 250;
    return Center(
      child:
          // Visibility(maintainState: true ,visible: facebookNativeAdLoaded, child: facebookNativeInterstitialAd())
          Stack(children: [
        Visibility(
            maintainState: true,
            visible: facebookNativeAdLoaded,
            child: facebookNativeInterstitialAd()),
        Positioned(
          child: !facebookNativeAdLoaded
              ? SpinKitRotatingPlain(color: Constant.selectedColor)
              : Container(height: 0, width: 0),
        )
      ]),
    );
  }

  Widget addNotePage(bool active) {
    // final double h = active ? 390 : 370;
    // final double w = active ? 300 : 240;
    if (!buttonDown) {
      height = active ? 330 : 290;
      width = active ? 260 : 200;
    }

    return Center(
        child: GestureDetector(
            onTapDown: (TapDownDetails details) => addNewStoryBtnClick(),
            onTap: () {
              setState(() {
                height = 290;
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
              child: Constant.primiumThemeSelected
                  ? PremiumAnimatedContainer(
                      height: height,
                      width: width,
                      child: AddStoryWidget(),
                    )
                  : NonPremiumAnimatedContainer(
                      height: height,
                      width: width,
                      child: AddStoryWidget(),
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
    bool response =
        await _customFirestore.deleteStory(story.date, story.images);
    if (response == true) {
      setState(() {
        GlobalData.storyList.remove(story);
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
    GlobalData.storyList = await _customFirestore.loadStoriesData();
    if (this.mounted) {
      setState(() {
        this.count = GlobalData.storyList.length;
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
  void moveToEndOfPage(index) {
    // pageController.animateToPage(
    //   count + 2,
    //   curve: Curves.easeIn,
    //   duration: Duration(milliseconds: 700),
    // );
    pageController.jumpToPage(index);
  }

  void moveToFirstPage() {
    // pageController.animateToPage(
    //   0,
    //   curve: Curves.easeIn,
    //   duration: Duration(milliseconds: 700),
    // );
    pageController.jumpToPage(0);
  }

  navigateToStoryDetailPage(story, currentIndex) async {
    //this will once load facebook ads and once admob ads
    if (Constant.facebooknative)
      Constant.facebooknative = false;
    else
      Constant.facebooknative = true;

    Story returnStory = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StoryDetail(story, currentIndex)));

    if (returnStory != null) {
      if (this.mounted) {
        setState(() {
          print('index to be updated: ' + currentIndex.toString());
          GlobalData.storyList[currentIndex - 1] = returnStory;
          print('story is edited on detail page');
        });
      }
    } else {
      print('No editing on detail page');
    }
  }

  //facebook native ad
  Widget facebookNativeInterstitialAd() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: FacebookNativeAd(
        placementId: "3663243730352300_3663359137007426",
        adType: NativeAdType.NATIVE_AD,
        width: 250,
        height: 350,
        backgroundColor: Constant.selectedColor,
        titleColor: Colors.white,
        descriptionColor: Colors.white,
        buttonColor: Constant.selectedColor,
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
          if (result == NativeAdResult.LOADED) {
            setState(() {
              print('Ad loaded');
              facebookNativeAdLoaded = true;
            });
          }
        },
      ),
    );
  }
}
