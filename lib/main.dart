import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kuku/screens/rootpage.dart';
import 'package:flutter/material.dart';
import 'package:kuku/utils/constant.dart';

import 'model/auth_provider.dart';
import 'model/authentication.dart';

// void main() => runApp(MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Constant.loadSettings();
  
  //admob ads initialize
  FirebaseAdMob.instance
      .initialize(appId: "ca-app-pub-5554760537482883~8172684706");
  //facebook ads
  FacebookAudienceNetwork.init(
    // testingId: "37b1da9d-b48c-4103-a393-2e095e734bd6", //optional
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
        auth: Auth(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'KUKU',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: RootPage(),
        ));
  }
}
