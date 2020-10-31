import 'package:kuku/utils/GlobalData.dart';
import 'package:kuku/utils/customfirestore.dart';
import 'package:kuku/widgets/PhotoHero.dart';
import 'package:kuku/model/Story.dart';
import 'package:kuku/screens/home_page.dart';
import 'package:kuku/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuku/widgets/nonpremiumcontainer.dart';
import 'package:kuku/widgets/premiumcontainer.dart';

class SaveStory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SaveStoryState();
  }
}

class SaveStoryState extends State {
  double minimumPadding = 5.0;
  Story story;
  TextEditingController titleConroller = TextEditingController();

  //circular progressbar (after save button click it will be appear)
  bool waiting = false;
  //form key
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constant.selectedColor,
        resizeToAvoidBottomPadding: false,
        body: Constant.primiumThemeSelected
            ? PremiumContainer(
                child: mainBody(),
                gradient: Constant.selectedGradient,
              )
            : NonPremiumContainer(
                child: mainBody(),
                color: Constant.selectedColor,
              ));
  }

  Widget mainBody() {
    return Form(
      key: _formKey,
      child: Builder(
        builder: (BuildContext context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Hero(
                  tag: 'cancel',
                  child: Padding(
                      padding: EdgeInsets.only(
                          top: minimumPadding * 8, right: minimumPadding * 4),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            icon: Image.asset('images/cancelwhite.png'),
                            iconSize: 10,
                            onPressed: () {
                              moveToLastScreen();
                            }),
                      ))),
              // Hero(tag: "logo", child: getLogoImage()),
              Padding(
                padding: EdgeInsets.only(bottom: minimumPadding * 4),
                child: PhotoHero(
                  photo: 'images/logo.png',
                  width: 80,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: minimumPadding),
                child: Text('Give your story a title',
                    style: TextStyle(fontSize: 22, color: Colors.white)),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: minimumPadding * 15,
                  left: minimumPadding * 8,
                  right: minimumPadding * 8,
                  bottom: minimumPadding * 8,
                ),
                child: TextFormField(
                  controller: titleConroller,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white70),
                    hintText: 'Add Title ...',
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 15),
                  validator: (value) {
                    if (value.length > 40) {
                      return 'Title length must be less than 40 Characters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    GlobalData.title = titleConroller.text;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: minimumPadding * 10),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white,
                  onPressed: () {
                    saveStory(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: minimumPadding * 3,
                        left: minimumPadding * 5,
                        bottom: minimumPadding * 3,
                        right: minimumPadding * 5),
                    child: Text(
                      'SAVE STORY',
                      style: TextStyle(
                          color: Constant.color5,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Visibility(
                visible: waiting,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  strokeWidth: 3,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Constant.selectedColor),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget getLogoImage() {
    AssetImage assetImage = AssetImage('images/logo.png');
    Image logo = Image(
      image: assetImage,
      width: 80,
      height: 80,
    );
    return Container(
      child: logo,
      margin: EdgeInsets.only(top: minimumPadding, bottom: minimumPadding * 5),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }

  void saveStory(BuildContext context) async {
    //first check form validation
    if (_formKey.currentState.validate()) {
      List<String> listOfDownloadUrl = [];
      int imagesSize = 0;
      //cicular progress bar
      startProgressAnimation();

      CustomFirestore _customFirestore = CustomFirestore();
      //first upload images to storage, if selected
      if (GlobalData.images == null) print('it null');
      if (GlobalData.images != null) {
        for (int i = 0; i < GlobalData.images.length; i++) {
          var dowUrl_Size = await _customFirestore
              .saveImageToFirestoreStorage(GlobalData.images[i]);
          print('dowUrl: ' + dowUrl_Size.toString());
          imagesSize += int.parse(dowUrl_Size[1]);
          listOfDownloadUrl.add(dowUrl_Size[0]);
        }
      }

      _customFirestore.addStoryToFirestore(
          title: GlobalData.title,
          date: GlobalData.date,
          feeling: GlobalData.feeling,
          reason: GlobalData.reason,
          whatHappened: GlobalData.whatHappened,
          dowImagesList: listOfDownloadUrl,
          imagesSize: imagesSize
          // note: GlobalData.note,
          );

      //now add story to GlobalData.storylist
      Story story = Story(
          GlobalData.title,
          GlobalData.date,
          GlobalData.feeling,
          GlobalData.reason,
          GlobalData.whatHappened,
          listOfDownloadUrl,
          imagesSize);
      GlobalData.storyList.add(story);

      waiting = false;

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    storyAdded: true,
                  )),
          (Route<dynamic> route) => false);

      // if (result == 'success') {
      //   Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) => HomePage(
      //                 storyAdded: true,
      //               )),
      //       (Route<dynamic> route) => false);
      // } else {
      //   setState(() {
      //     waiting = false;
      //     showSnackBar(context, result);
      //   });
      // }
    }
  }

  void showSnackBar(context, msg) {
    SnackBar snackbar = SnackBar(content: Text(msg));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  startProgressAnimation() {
    setState(() {
      waiting = true;
    });
  }
}
