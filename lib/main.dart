import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kuku/screens/rootpage.dart';
import 'package:flutter/material.dart';
import 'package:kuku/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/auth_provider.dart';
import 'model/authentication.dart';

// void main() => runApp(MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await loadSettings();
  //admob ads initialize
  FirebaseAdMob.instance.initialize(appId: "ca-app-pub-5554760537482883~8172684706");
  runApp(MyApp());
}

loadSettings() async {
  final prefs = await SharedPreferences.getInstance();
  final colorIndex = prefs.getInt('colorIndex') ?? 0;
  //Now initialize selectedColor
  Constant.selectedColor = Constant.listOfColors[colorIndex];
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
        auth: Auth(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'kuku',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            cursorColor: Colors.white54,
          ),
          home: RootPage(),
        ));
  }
}
