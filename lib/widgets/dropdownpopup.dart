import 'package:flutter/material.dart';
import 'package:koko/model/auth_provider.dart';
import 'package:koko/model/authentication.dart';
import 'package:koko/screens/add_story.dart';
import 'package:koko/screens/login_signup_page.dart';
import 'package:koko/screens/settingpage.dart';
import 'package:koko/utils/constant.dart';

class CustomDropDownPopup extends StatelessWidget {
  const CustomDropDownPopup({ Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text("Setting"),
          ),
          PopupMenuItem(
            value: 2,
            child: Text("Add Story"),
          ),
          PopupMenuItem(
            value: 3,
            child: Text("Signout"),
          ),
        ],
        initialValue: 4,
        onCanceled: () {
          print("You have canceled the menu.");
        },
        onSelected: (value) {
          print("value:$value");
          if (value == 1)
            navigateToSettingPage(context);
          else if (value == 2) 
            navigateToAddNewStoryPage(context);
          else
            signOut(context);
        },
        icon: Icon(
          Icons.arrow_drop_down,
          color: Constant.selectedColor,
          size: 40,
        ),
      );
  }

  Future<void> signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();

      // //clear user data so when another user login with same phone, no unexpected data open
      // _userData.clearUserData();

      //due to some issue, i will navigate to login page manually
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return LoginPage();
        },
      ));
    } catch (e) {
      print(e);
    }
  }

  navigateToSettingPage(context) {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return SettingPage();
        },
      ));
  }

  navigateToAddNewStoryPage(context) {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return AddStory();
        },
      ));
  }
}