import 'package:koko/model/auth_provider.dart';
import 'package:koko/model/authentication.dart';
import 'package:koko/screens/home_page.dart';
import 'package:koko/screens/login_signup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('HELLO');
    final BaseAuth auth = AuthProvider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        if (snapshot.connectionState == ConnectionState.active){
          final bool isLoggedIn = snapshot.hasData;
          String uid = snapshot.data;
          // debugPrint('data: '+uid.toString());
          return isLoggedIn ? HomePage(useruid: uid,) : LoginPage();
        }
        return _buildWaitingScreen(context);
        //should return splash screen here
      },
    );
  }

  Widget _buildWaitingScreen(BuildContext context) {
    return Center(
        child: Container(
      height: 170.0,
      width: 170.0,
      decoration: new BoxDecoration(
        image: DecorationImage(
          image: new AssetImage('images/logo.png'),
          fit: BoxFit.fill,
        ),
        shape: BoxShape.circle,
      ),
    ));
  }

}