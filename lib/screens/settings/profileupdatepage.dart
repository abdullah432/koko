import 'package:flutter/material.dart';
import 'package:kuku/screens/home_page.dart';
import 'package:kuku/utils/constant.dart';
import 'package:kuku/utils/customfirestore.dart';
import 'package:kuku/widgets/nonpremiumcontainer.dart';
import 'package:kuku/widgets/premiumcontainer.dart';
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
        appBar: AppBar(
          backgroundColor: Constant.primiumThemeSelected
              ? Constant.gradientStartColor
              : Constant.selectedColor,
          title: Text('Profile & Theme'),
        ),
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
    return GestureDetector(
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
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: RaisedButton(
                    onPressed: () {
                      saveUserNameAndColor();
                    },
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Constant.selectedColor),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //save logic
  saveUserNameAndColor() async {
    if (_formKey.currentState.validate()) {
      startProgressAnimation();

      if (Constant.username != nameController.text) {
        CustomFirestore _customFirestore = CustomFirestore();
        _customFirestore.updateUserName(nameController.text);
        Constant.username = nameController.text;
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
