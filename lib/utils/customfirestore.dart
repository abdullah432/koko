import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:koko/model/Story.dart';
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

  loadStoriesData() async {
    DocumentReference docRef = db.collection('users').doc(Constant.useruid);
    print(docRef.toString());
    QuerySnapshot querySnapshot = await db
        .collection("stories")
        .where('reference', isEqualTo: docRef)
        .get();

    Story story;
    List<Story> listOfStory = List();
    querySnapshot.docs.forEach((DocumentSnapshot snapshot) {
      story = Story.fromSnapshot(snapshot);
      listOfStory.add(story);
    });
    return listOfStory;
  }

  Future<bool> addStoryToFirestore({
    @required String title,
    @required String date,
    @required String feeling,
    @required String reason,
    @required String whatHappened,
    @required String note,
  }) async {
    try {
      await db.collection("stories").add({
        'title': title,
        'date': date,
        'feeling': feeling,
        'reference': db.collection('users').doc(Constant.useruid),
        'reason': reason,
        'whatHappened': whatHappened,
        'note': note,
      }).whenComplete(() {
        return true;
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
}
