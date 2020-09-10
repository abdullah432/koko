import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:koko/utils/constant.dart';
import 'package:meta/meta.dart';

class CustomFirestore {
  // User _user = new User();
  final db = FirebaseFirestore.instance;
  loadUserName({@required userid}) async {
    var snapshot = await db.collection('users').doc(userid).get();
    String name = snapshot.data()['name'];
    Constant.username = name;
  }
}