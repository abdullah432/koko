import 'package:kuku/utils/GlobalData.dart';
import 'package:kuku/widgets/PhotoHero.dart';
import 'package:kuku/screens/reason.dart';
import 'package:kuku/utils/constant.dart';
import 'package:flutter/material.dart';

class FeelingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FeelingPageState();
  }
}

class FeelingPageState extends State<FeelingPage> {
  final minimumPadding = 5.0;
  double rating = 2;
  String feeling = 'COMPLETELY OK';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox.expand(
            child: Constant.primiumThemeSelected
                ? FeelingPremiumContainer(
                    child: mainBody(),
                    gradient: Constant.selectedGradient,
                  )
                : Feeling_NonPremiumContainer(
                    child: mainBody(),
                    color: Constant.selectedColor,
                  )));
  }

  Widget mainBody() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: minimumPadding * 8, left: minimumPadding * 3),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: PhotoHero(
                    photo: 'images/logo.png',
                    width: 55,
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: minimumPadding * 8, right: minimumPadding * 4),
              child: IconButton(
                  icon: Image.asset('images/cancelwhite.png'),
                  iconSize: 10,
                  onPressed: () {
                    moveToLastScreen();
                  }),
            )
          ],
        ),
        Padding(
            padding: EdgeInsets.only(
                top: minimumPadding * 4, left: minimumPadding * 4),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'How was your day, today?',
                style: TextStyle(color: Colors.white, fontSize: 21.0),
              ),
            )),
        Padding(
            padding: EdgeInsets.only(
                top: minimumPadding * 15, bottom: minimumPadding * 5),
            child: getEmojiImage(80)),
        SliderTheme(
          child: Slider(
            max: 3,
            min: 1,
            value: rating,
            onChanged: (double newRating) {
              setState(() => rating = newRating);
            },
            onChangeEnd: (double) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ReasonPage()));
              GlobalData.feeling = feeling;
            },
            // divisions: 2,
            activeColor: Colors.white,
            inactiveColor: Color(0xffC6AEE7),
          ),
          data: SliderThemeData(trackHeight: 4),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: minimumPadding * 3, right: minimumPadding * 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'RATE YOUR DAY',
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    fontSize: 15),
              ),
              Text(
                feeling,
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget getLogoImage(String path, double size) {
    AssetImage assetImage = AssetImage(path);
    Image logo = Image(
      image: assetImage,
      width: size,
      height: size,
      color: Colors.white,
    );
    return Container(
      child: logo,
      margin:
          EdgeInsets.only(top: minimumPadding * 5, left: minimumPadding * 5),
    );
  }

  Widget getEmojiImage(double size) {
    String path;
    switch (rating.round()) {
      case 1:
        path = 'images/sad emoji.png';
        feeling = 'SAD';
        break;
      case 2:
        path = 'images/completlyOk.png';
        feeling = 'COMPLETELY OK';
        break;
      case 3:
        path = 'images/happy emoji.png';
        feeling = 'HAPPY';
        break;
    }
    AssetImage assetImage = AssetImage(path);
    Image logo = Image(
      image: assetImage,
      width: size,
      height: size,
      color: Colors.white,
    );
    return Container(
      child: logo,
      margin:
          EdgeInsets.only(top: minimumPadding * 5, left: minimumPadding * 5),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }
}

//beacuse main container have singlechildscrollview
//So there is slider issue
class FeelingPremiumContainer extends StatelessWidget {
  final child;
  LinearGradient gradient;
  FeelingPremiumContainer({@required this.child, @required this.gradient, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height >= 775.0
          ? MediaQuery.of(context).size.height
          : 775.0,
      decoration: BoxDecoration(gradient: gradient),
      child: child,
    );
  }
}

class Feeling_NonPremiumContainer extends StatelessWidget {
  final child;
  Color color;
  Feeling_NonPremiumContainer({@required this.child, @required this.color, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height >= 775.0
          ? MediaQuery.of(context).size.height
          : 775.0,
      color: color,
      child: child,
    );
  }
}
