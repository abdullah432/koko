import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kuku/model/Story.dart';
import 'package:kuku/utils/constant.dart';
import 'package:meta/meta.dart';

class CustomFirestore {
  // User _user = new User();
  final db = FirebaseFirestore.instance;

  loadUserName({@required userid}) async {
    var snapshot = await db.collection('users').doc(userid).get();
    String name = snapshot.data()['name'];
    Constant.username = name;
  }

  loadStoriesData() async {
    // DocumentReference docRef = db.collection('users').doc(Constant.useruid);
    // print(docRef.toString());
    // QuerySnapshot querySnapshot = await db
    //     .collection("stories")
    //     .where('reference', isEqualTo: docRef)
    //     .get();

    QuerySnapshot querySnapshot =
        await db.collection('users').doc(Constant.useruid).collection("stories").get();

    Story story;
    List<Story> listOfStory = List();
    querySnapshot.docs.forEach((DocumentSnapshot snapshot) {
      story = Story.fromSnapshot(snapshot);
      listOfStory.add(story);
    });
    return listOfStory;
  }

  Future<String> addStoryToFirestore({
    @required String title,
    @required String date,
    @required String feeling,
    @required String reason,
    @required String whatHappened,
    @required String note,
  }) async {
    try {
      await db.collection('users').doc(Constant.useruid).collection("stories").doc(date).set({
        'title': title,
        'date': date,
        'feeling': feeling,
        // 'reference': db.collection('users').doc(Constant.useruid),
        'reason': reason,
        'whatHappened': whatHappened,
        'note': note,
      }).whenComplete(() {
        return 'success';
      }).catchError((error) {
        print('error during adding service: ' + error.toString());
        return error.toString();
      });
    } on SocketException {
      return 'Please check your internet connection';
    } catch (error) {
      print('exception during adding service: ' + error.toString());
      return error.toString();
    }
    return 'success';
  }

  Future<bool> deleteStory(date) async {

    try {
      await db
          .collection("users")
          .doc(Constant.useruid)
          .collection('stories')
          .doc(date)
          .delete()
          .whenComplete(() {
        return true;
      }).timeout(Duration(seconds: 10), onTimeout: () {
        // handle transaction timeout here
      }).catchError((onError) {
        print('error during adding service: ' + onError.toString());
        return false;
      });
    } catch (e) {
      print('exception during adding service: ' + e.toString());
      return false;
    }
    return true;
  }

  void updateUserName(name) {
    db.collection('users').doc(Constant.useruid).set({
      'name': name
    });
  }

  Future<String> loadPrivacyPolicyUrl() async{
    DocumentSnapshot documentSnapshot = await db.collection('useful').doc('mMUOdFKkb5xt3DfXUiIj').get();
    String url = documentSnapshot.data()['privacypolicy'];
    return url;
  }
}
