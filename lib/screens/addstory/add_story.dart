import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kuku/utils/GlobalData.dart';
import 'package:kuku/widgets/PhotoHero.dart';
import 'package:kuku/utils/constant.dart';
import 'package:kuku/widgets/nonpremiumcontainer.dart';
import 'package:kuku/widgets/premiumcontainer.dart';

import 'feeling.dart';

class AddStory extends StatefulWidget {
  AddStory({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return AddStoryState();
  }
}

class AddStoryState extends State<AddStory> {
  final minimumPadding = 5.0;
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(
                top: minimumPadding * 8, right: minimumPadding * 4),
            child: Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  moveToLastScreen();
                },
                child: Icon(
                  FlutterIcons.cross_ent,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            )),
        // Hero(tag: "logo", child: getLogoImage()),
        Padding(
          padding: EdgeInsets.only(bottom: minimumPadding * 4),
          child: PhotoHero(
            photo: 'images/logo.png',
            width: 80,
          ),
        ),
        Text('Good ${Constant.greeting()} ${Constant.username}',
            style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w500)),
        Padding(
          padding: EdgeInsets.only(top: minimumPadding),
          child: Text('ready to create a new story?',
              style: TextStyle(fontSize: 22, color: Colors.white)),
        ),
        Padding(
          padding: EdgeInsets.only(top: minimumPadding * 15),
          child: FlatButton(
              onPressed: () {
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(2018, 1, 1),
                    maxTime: DateTime(2199, 12, 31), onChanged: (date) {
                  print('change $date');
                }, onConfirm: (date) {
                  setState(() {
                    this.date = date;
                  });
                }, currentTime: DateTime.now(), locale: LocaleType.en);
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      formatDate(date, [MM, ' ', dd]),
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 40,
                      color: Colors.white,
                    )
                  ])),
        ),
        Padding(
          padding: EdgeInsets.only(top: minimumPadding * 15),
          child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.white,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FeelingPage()));
              GlobalData.date = this.date.toString();
            },
            child: Padding(
              padding: EdgeInsets.only(
                  top: minimumPadding * 3,
                  left: minimumPadding * 5,
                  bottom: minimumPadding * 3,
                  right: minimumPadding * 5),
              child: Text(
                'LETS DO IT!',
                style: TextStyle(
                    color: Constant.color5,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
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
}
