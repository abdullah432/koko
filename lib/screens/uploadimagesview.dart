import 'package:kuku/utils/GlobalData.dart';
import 'package:kuku/widgets/PhotoHero.dart';
import 'package:kuku/screens/saveStory.dart';
import 'package:kuku/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuku/widgets/imagesgridview.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImagesView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ImagesViewState();
  }
}

class ImagesViewState extends State<ImagesView> {
  double minimumPadding = 5.0;
  bool buttonVisibility = true;
  bool imagesViewVisibility = false;
  TextEditingController noteController = TextEditingController();

  //images picker
  List<Asset> images = List<Asset>();
  String _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SizedBox.expand(
        child: Constant.primiumThemeSelected
            ? ImagePremiumContainer(
                child: mainBody(),
                gradient: Constant.selectedGradient,
              )
            : ImageNonPremiumContainer(
                child: mainBody(),
                color: Constant.selectedColor,
              ),
      ),
    );
  }

  Widget mainBody() {
    return SingleChildScrollView(
      child: Column(
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
                  top: minimumPadding * 4,
                  left: minimumPadding * 4,
                  right: minimumPadding * 4,
                  bottom: minimumPadding * 4),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Would you like to add some images?',
                  style: TextStyle(color: Colors.white, fontSize: 22.0),
                ),
              )),
          Visibility(
              visible: buttonVisibility,
              child: Padding(
                padding: EdgeInsets.only(top: minimumPadding * 25),
                child: RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: minimumPadding * 8,
                      right: minimumPadding * 8,
                      top: minimumPadding * 3,
                      bottom: minimumPadding * 3,
                    ),
                    child: Text(
                      'Yes',
                      style: TextStyle(
                          color: Constant.color5,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      loadAssets();
                      yesButtonLogic();
                    });
                  },
                ),
              )),
          Visibility(
              visible: buttonVisibility,
              child: Padding(
                padding: EdgeInsets.only(top: minimumPadding * 4),
                child: FlatButton(
                    child: Text(
                      'No Thanks',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () {
                      if (images != null) {
                        GlobalData.images = images;
                      }
                        
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SaveStory()));
                    }),
              )),
          Visibility(
            visible: imagesViewVisibility,
            child: ImagesGridView(images: images,),
            // GridView.count(
            //   // Create a grid with 2 columns. If you change the scrollDirection to
            //   // horizontal, this produces 2 rows.
            //   crossAxisCount: 3,
            //   // Generate 100 widgets that display their index in the List.
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   children: List.generate(3, (index) {
            //     return Center(
            //         child: Container(
            //       height: 90,
            //       width: 90,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10),
            //         color: Colors.white,
            //       ),
            //     ));
            //   }),
            // ),
          ),
          Padding(
              padding: EdgeInsets.only(top: minimumPadding * 3),
              child: Align(
                  alignment: Alignment.topRight,
                  child: FlatButton(
                    onPressed: () {
                      if (images != null) {
                        GlobalData.images = images;
                      }
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SaveStory()));
                    },
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Icon(
                        Icons.navigate_next,
                        size: 40.0,
                        color: Colors.white,
                      ),
                    ),
                  )))
        ],
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }

  void yesButtonLogic() {
    buttonVisibility = false;
    imagesViewVisibility = true;
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      print('***setstate called***');
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }
}

//custom container classes

class ImagePremiumContainer extends StatelessWidget {
  final child;
  LinearGradient gradient;
  ImagePremiumContainer(
      {@required this.child, @required this.gradient, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height >= 775.0
      //     ? MediaQuery.of(context).size.height
      //     : 775.0,
      decoration: BoxDecoration(gradient: gradient),
      child: child,
    );
  }
}

class ImageNonPremiumContainer extends StatelessWidget {
  final child;
  Color color;
  ImageNonPremiumContainer(
      {@required this.child, @required this.color, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height >= 775.0
      //     ? MediaQuery.of(context).size.height
      //     : 775.0,
      color: color,
      child: child,
    );
  }
}
