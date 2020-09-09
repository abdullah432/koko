import 'package:firebase_core/firebase_core.dart';
import 'package:koko/screens/rootpage.dart';
import 'package:flutter/material.dart';

import 'model/auth_provider.dart';
import 'model/authentication.dart';

// void main() => runApp(MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
          title: 'KoKo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            cursorColor: Colors.white54,
          ),
          home: RootPage(),
        ));
  }
}
