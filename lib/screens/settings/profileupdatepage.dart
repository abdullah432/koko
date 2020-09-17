import 'package:flutter/material.dart';
import 'package:kuku/screens/home_page.dart';
import 'package:kuku/utils/constant.dart';
import 'package:kuku/utils/customfirestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileUpdate extends StatefulWidget {
  ProfileUpdate({Key key}) : super(key: key);

  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  TextEditingController nameController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  //selected color index will be saved and in root page will be retrieve and
  //selectedColor will be initialize with the help of this index from list of colors
  int colorIndex = -1;
  //waiting for data to save
  bool waiting = false;
  @override
  void initState() {
    nameController.text = Constant.username;
    super.initState();
  }

  @override
  dispose() {
    nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.selectedColor,
      appBar: AppBar(
        backgroundColor: Constant.selectedColor,
        title: Text('Profile & Theme'),
      ),
      body: GestureDetector(
        onTap: () {
          _focusNode.unfocus();
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextFormField(
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white, fontSize: 22.0),
                        controller: nameController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 10.0),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Container(
                    height: 110.0,
                    child: ListView.builder(
                      itemBuilder: buildContainer,
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: RaisedButton(
                      onPressed: () {
                        saveUserNameAndColor();
                      },
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Update',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Constant.selectedColor,
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
                      valueColor: AlwaysStoppedAnimation<Color>(Constant.selectedColor),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildContainer(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          Constant.selectedColor = Constant.listOfColors[index];
          colorIndex = index;
        });
      },
      child: Container(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          width: 80,
          // height: 20,
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

  //save logic
  saveUserNameAndColor() async {
    if (_formKey.currentState.validate()) {
      startProgressAnimation();
      // obtain shared preferences
      final prefs = await SharedPreferences.getInstance();
      if (Constant.username != nameController.text) {
        CustomFirestore _customFirestore = CustomFirestore();
        _customFirestore.updateUserName(nameController.text);
        Constant.username = nameController.text;
      }
      //if colorindex not equal to -1 that means user select new color
      if (colorIndex != -1) {
        prefs.setInt('colorIndex', colorIndex);
        Constant.selectedColor = Constant.listOfColors[colorIndex];
      }
      //hide animation (circular progressbar)
      waiting = false;
      //now navigate to homepage
      navigateToHomePage();
    }
  }

  navigateToHomePage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  startProgressAnimation() {
    setState(() {
      waiting = true;
    });
  }
}
