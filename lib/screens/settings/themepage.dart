import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kuku/utils/constant.dart';
import 'package:kuku/utils/customfirestore.dart';
import 'package:kuku/widgets/nonpremiumcontainer.dart';
import 'package:kuku/widgets/premiumcontainer.dart';
import 'package:kuku/styles/gradientcolors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePage extends StatefulWidget {
  ThemePage({Key key}) : super(key: key);

  @override
  _ThemePageState createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  //when user update new them by clicking on check box
  bool _newThemeUpdated = false;
  //check either user select new theme or not
  bool _themeUpdated = false;
  //to make sure changes only apply in this page. We will create custom parameter
  bool premiumThemeAvailable = false;
  bool primiumThemeSelected = Constant.primiumThemeSelected;
  LinearGradient selectedGradient = Constant.selectedGradient;
  Color gradientStartColor = Constant.gradientStartColor;
  Color selectedColor = Constant.selectedColor;
  //use when update theme after clicking on check icon
  int selectedThemIndex;
  //theme update in progress
  bool _newThemeUpdateInProgress = false;
  //Snackbar
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //ad loading in progress
  bool adLoadingInProgress = false;
  bool adFailedToLoad = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor:
                primiumThemeSelected ? gradientStartColor : selectedColor,
            title: Text('Theme'),
            actions: [
              Visibility(
                visible: _themeUpdated,
                child: _newThemeUpdateInProgress
                    ? Padding(
                        padding: const EdgeInsets.only(
                            right: 15.0, top: 8.0, bottom: 8.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _newThemeUpdateInProgress = true;
                            updateNewTheme();
                          });
                        },
                      ),
              )
            ],
          ),
          body: primiumThemeSelected
              ? PremiumContainer(
                  child: mainBody(),
                  gradient: selectedGradient,
                )
              : NonPremiumContainer(
                  child: mainBody(),
                  color: selectedColor,
                )),
    );
  }

  Widget mainBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 30),
          child: Text(
            'Free Theme',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        nonPremiumThemeGridView(),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Text(
            'Premium Theme',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        premiumThemeGridView(),
      ],
    );
  }

  nonPremiumThemeGridView() {
    return GridView.builder(
      itemBuilder: circularNoPremiumTheme,
      itemCount: Constant.listOfColors.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      shrinkWrap: true,
    );
  }

  premiumThemeGridView() {
    return GridView.builder(
      itemBuilder: circularPremiumTheme,
      itemCount: Constant.listOfPremium.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      shrinkWrap: true,
    );
  }

  Widget circularNoPremiumTheme(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedThemIndex = index;
          selectedColor = Constant.listOfColors[index];
          primiumThemeSelected = false;
          _themeUpdated = true;
        });
      },
      child: Container(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          // width: 60,
          decoration: BoxDecoration(
            color: Constant.listOfColors[index], //this is the important line
            borderRadius: BorderRadius.all(Radius.circular(100.0)),
            border: Border.all(color: Colors.white, width: 4.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget circularPremiumTheme(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedThemIndex = index;
          selectedGradient = Constant.listOfPremium[index];
          primiumThemeSelected = true;
          premiumThemeAvailable = Constant.unlockTheme[index];
          //for appbar color
          gradientStartColor = GradientColors.listOfGradientStartColor[index];
          _themeUpdated = true;
        });
      },
      child: Stack(
        children: [
          Container(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              // width: 60,
              decoration: BoxDecoration(
                gradient:
                    Constant.listOfPremium[index], //this is the important line
                borderRadius: BorderRadius.all(Radius.circular(100.0)),
                border: Border.all(color: Colors.white, width: 4.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
            ),
          )),
          Positioned(
              child: Center(
                  child: Constant.unlockTheme[index]
                      ? Container()
                      : Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 30,
                        ))),
        ],
      ),
    );
  }

  updateNewTheme() async {
    if (primiumThemeSelected) {
      if (premiumThemeAvailable) {
        _newThemeUpdated = true;
        Constant.selectedGradient = Constant.listOfPremium[selectedThemIndex];
        Constant.primiumThemeSelected = true;
        //for appbar color
        Constant.gradientStartColor =
            GradientColors.listOfGradientStartColor[selectedThemIndex];
        //update button color
        Constant.selectedButtonGradient =
            Constant.listOfPremiumButtons[selectedThemIndex];

        //update local storage
        updateLocalStorage();

        updateThemeSuccess();
      } else {
        //show rewarded ads
        setState(() {
          _newThemeUpdateInProgress = false;
          adLoadingInProgress = false;
          adFailedToLoad = false;
          _showMaterialDialog();
        });
      }
    } else {
      //this mean new theme is updated and now on back button previous page should be updated
      _newThemeUpdated = true;

      updateLocalStorage();
      //
      if (primiumThemeSelected) {
      } else {
        Constant.selectedColor = Constant.listOfColors[selectedThemIndex];
        Constant.primiumThemeSelected = false;
      }

      updateThemeSuccess();
    }
  }

  updateThemeSuccess() {
    setState(() {
      _themeUpdated = false;
      _newThemeUpdateInProgress = false;
      showInSnackBar('Theme successfully updated');
    });
  }

  updateLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedThemIndex', selectedThemIndex);
    prefs.setBool('primiumThemeSelected', primiumThemeSelected);
  }

  Future<bool> _onBackPressed() {
    if (_newThemeUpdated)
      Navigator.pop(context, true);
    else
      return Future.value(true);
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                  title: Text("Unlock Theme"),
                  content: RaisedButton(
                    onPressed: () {
                      setState(() {
                        print('watch ad');
                        adLoadingInProgress = true;
                      });
                      showRewardedVideoAd(context);
                    },
                    color: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: adLoadingInProgress
                          ? Text(
                              adFailedToLoad
                                  ? 'Ad Fail to Load'
                                  : 'AD LOADING ...',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(FlutterIcons.unlock_alt_faw5s),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'WATCH AD',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )
                              ],
                            ),
                    ),
                  ));
            },
          );
        });
  }

  showRewardedVideoAd(context) {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "3663243730352300_3707040615972611",
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED)
          FacebookInterstitialAd.showInterstitialAd();

        if (result == InterstitialAdResult.DISPLAYED) {
          setState(() {
            print("Video displayed");
            _newThemeUpdated = true;
            Constant.selectedGradient =
                Constant.listOfPremium[selectedThemIndex];
            Constant.primiumThemeSelected = true;
            //for appbar color
            Constant.gradientStartColor =
                GradientColors.listOfGradientStartColor[selectedThemIndex];
            //update button color
            Constant.selectedButtonGradient =
                Constant.listOfPremiumButtons[selectedThemIndex];

            //update local storage
            updateLocalStorage();

            Constant.unlockTheme[selectedThemIndex] = true;
            CustomFirestore _customF = CustomFirestore();
            _customF.updateThemeData();
            updateLocalStorage();
            //dispose dialog box
            Navigator.pop(context);
            //remove checkbox
          });
        }

        if (result == InterstitialAdResult.ERROR) {
          setState(() {
            Navigator.pop(context);
            //show success msg
            showInSnackBar('Ad failed to laod. Please try again');
          });
        }

        if (result == InterstitialAdResult.DISMISSED) {
          updateThemeSuccess();
        }
      },
    );
  }
  // FacebookRewardedVideoAd.loadRewardedVideoAd(
  //   placementId: "3663243730352300_3707040615972611",
  //   listener: (result, value) {
  //     if (result == RewardedVideoAdResult.LOADED)
  //       FacebookRewardedVideoAd.showRewardedVideoAd();
  //     if (result == RewardedVideoAdResult.VIDEO_COMPLETE) {
  //       setState(() {
  //         print("Video completed");
  //         _newThemeUpdated = true;
  //         Constant.selectedGradient =
  //             Constant.listOfPremium[selectedThemIndex];
  //         Constant.primiumThemeSelected = true;
  //         //for appbar color
  //         Constant.gradientStartColor =
  //             GradientColors.listOfGradientStartColor[selectedThemIndex];
  //         //update button color
  //         Constant.selectedButtonGradient =
  //             Constant.listOfPremiumButtons[selectedThemIndex];

  //         //update local storage
  //         updateLocalStorage();

  //         Constant.unlockTheme[selectedThemIndex] = true;
  //         CustomFirestore _customF = CustomFirestore();
  //         _customF.updateThemeData();
  //         updateLocalStorage();
  //         //dispose dialog box
  //         Navigator.pop(context);
  //         //remove checkbox
  //       });
  //     }

  //     if (result == RewardedVideoAdResult.ERROR) {
  //       setState(() {
  //         Navigator.pop(context);
  //         //show success msg
  //         showInSnackBar('Ad failed to laod. Please try again');
  //       });
  //     }

  //     if (result == RewardedVideoAdResult.VIDEO_CLOSED) {
  //       updateThemeSuccess();
  //     }
  //   },
  // );
}
