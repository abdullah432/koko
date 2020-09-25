import 'package:kuku/model/auth_provider.dart';
import 'package:kuku/model/authentication.dart';
import 'package:kuku/screens/home_page.dart';
import 'package:kuku/screens/login_signup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuku/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BaseAuth auth = AuthProvider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool isLoggedIn = snapshot.hasData;
          String uid = snapshot.data;
          Constant.useruid = uid;
          // debugPrint('data: '+uid.toString());
          return isLoggedIn ? HomePage() : LoginPage();
        }
        return WaitingPage();
        //should return splash screen here
      },
    );
  }

}

class WaitingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Waiting to load ....');
    return Container(
      color: Constant.selectedColor,
      child: Center(
        child: Container(
          height: 130.0,
          width: 130.0,
          decoration: new BoxDecoration(
            image: DecorationImage(
              image: new AssetImage('images/logo.png'),
              fit: BoxFit.fill,
            ),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
