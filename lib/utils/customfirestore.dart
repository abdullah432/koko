import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kuku/model/Post.dart';
import 'package:kuku/model/Story.dart';
import 'package:kuku/utils/constant.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

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

    QuerySnapshot querySnapshot = await db
        .collection('users')
        .doc(Constant.useruid)
        .collection("stories")
        .get();

    Story story;
    List<Story> listOfStory = List();
    querySnapshot.docs.forEach((DocumentSnapshot snapshot) {
      story = Story.fromSnapshot(snapshot);
      listOfStory.add(story);
    });
    return listOfStory;
  }

  Future<List<String>> saveImageToFirestoreStorage(Asset asset) async {
    ByteData byteData = await asset.getByteData(
        quality: 30); // requestOriginal is being deprecated
    List<int> imageData = byteData.buffer.asUint8List();
    StorageReference ref = FirebaseStorage().ref().child(
        "${asset.name}"); // To be aligned with the latest firebase API(4.0)
    StorageUploadTask uploadTask = ref.putData(imageData);
    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    return [dowurl.toString(), byteData.lengthInBytes.toString()];
  }

  Future<String> addStoryToFirestore({
    @required String title,
    @required String date,
    @required String feeling,
    @required String reason,
    @required String whatHappened,
    @required List<String> dowImagesList,
    @required int imagesSize,
    // @required String note,
  }) async {
    try {
      await db
          .collection('users')
          .doc(Constant.useruid)
          .collection("stories")
          .doc(date)
          .set({
        'title': title,
        'date': date,
        'feeling': feeling,
        // 'reference': db.collection('users').doc(Constant.useruid),
        'reason': reason,
        'whatHappened': whatHappened,
        'images': dowImagesList,
        'imagesSize': imagesSize,
        // 'note': note,
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

  Future<String> updateStoryToFirestore({@required Story story}) async {
    try {
      await db
          .collection('users')
          .doc(Constant.useruid)
          .collection("stories")
          .doc(story.date)
          .update({
        'title': story.title,
        'date': story.date,
        'feeling': story.feeling,
        'reason': story.reason,
        'whatHappened': story.whatHappened,
        'images': story.images,
        'imagesSize': story.imagesSize
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

  Future<bool> deleteStory(date, images) async {
    try {
      await db
          .collection("users")
          .doc(Constant.useruid)
          .collection('stories')
          .doc(date)
          .delete()
          .whenComplete(() {
        //delete images if exists
        if (images != null && images.length > 0) {
          print('images exists');
          deleteUserImagesFromFirebaseStorage(images);
        }

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

  //public stories
  loadPublicStoriesData() async {
    // QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("posts").get();
    // var list = querySnapshot.docs;

    QuerySnapshot querySnapshot = await db.collection('posts').get();

    Post post;
    List<Post> listOfPosts = List();

    querySnapshot.docs.forEach((DocumentSnapshot snapshot) async{
      post = Post.fromSnapshot(snapshot);
      QuerySnapshot isPostLiked = await db.collection('posts').doc(post.postid).collection('list1').where(Constant.useruid, isEqualTo: true).get();
      if(isPostLiked.docs.contains(Constant.useruid)) {
        print('isPostLiked: true');
      } else {
        print('isPostLiked: false');
      }
      listOfPosts.add(post);
    });

    return listOfPosts;
  }

  //share post
  Future<bool> shareUserPostToFireStore({@required Story story}) async {
    db.collection('posts').doc().set({
      'title': story.title,
      'date': story.date,
      'feeling': story.feeling,
      'reason': story.reason,
      'whatHappened': story.whatHappened,
      'images': story.images,
      'createdby': Constant.useruid,
      'totallikes': 0,
      'totalcomments': 0,
    }).whenComplete(() {
      print('complete');
      return true;
    }).catchError((error) {
      print('error during adding service: ' + error.toString());
      return false;
    });
    return true;
  }

  //is post like by user
  isPostLiked({@required postid}) async {
    final DocumentSnapshot docSnap = await db
        .collection("posts")
        .doc(postid)
        .collection('likedbyusers')
        .doc('list1')
        .get();
    if (docSnap.data().containsKey(Constant.useruid)) {
      return true;
    } else {
      return false;
    }
  }

  //update like
  updateLikeState({@required likedState, @required postid}) {
    if (likedState) {
      //increment
      final DocumentReference docRef = db.collection("posts").doc(postid);
      docRef.update({"totallikes": FieldValue.increment(1)});
      //add to subcollection likebyusers
      db
          .collection('posts')
          .doc(postid)
          .collection('likedbyusers')
          .doc('list1')
          .set({Constant.useruid: true});
    } else {
      //decrement
      final DocumentReference docRef = db.collection("posts").doc(postid);
      docRef.update({"totallikes": FieldValue.increment(-1)});
      //add to subcollection likebyusers
      db
          .collection('posts')
          .doc(postid)
          .collection('likedbyusers')
          .doc('list1')
          .update({Constant.useruid: FieldValue.delete()});
    }
  }

  deleteUserImagesFromFirebaseStorage(images) async {
    try {
      int deletedImagesSize = 0;
      for (String image in images) {
        print('Image link: ' + image);
        StorageReference ref =
            await FirebaseStorage().getReferenceFromUrl(image);
        StorageMetadata metadata = await ref.getMetadata();
        deletedImagesSize = metadata.sizeBytes;
        ref.delete();
      }
      return deletedImagesSize;
    } catch (error) {
      print('deleteUserImagesFromFirebaseStorage: ' + error.toString());
      return 0;
    }
  }

  deleteSingleImageFromStorage({@required imageURL}) async {
    try {
      StorageReference ref =
          await FirebaseStorage().getReferenceFromUrl(imageURL);
      ref.delete();
    } catch (error) {
      print('deleteUserImagesFromFirebaseStorage: ' + error.toString());
    }
  }

  void updateUserName(name) {
    db.collection('users').doc(Constant.useruid).set({'name': name});
  }

  Future<String> loadPrivacyPolicyUrl() async {
    DocumentSnapshot documentSnapshot =
        await db.collection('useful').doc('mMUOdFKkb5xt3DfXUiIj').get();
    String url = documentSnapshot.data()['privacypolicy'];
    return url;
  }

  Future loadUserSetting({@required uid}) async {
    try {
      DocumentSnapshot documentSnapshot = await db
          .collection('users')
          .doc(uid)
          .collection('setting')
          .doc('themesetting')
          .get();

      Constant.unlockTheme =
          List<bool>.from(documentSnapshot.data()['unlockTheme']);
      print('unlock Theme data loaded: ' + Constant.unlockTheme.toString());
    } catch (error) {
      print('version 1.0.2 user');
      Constant.unlockTheme = [
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false
      ];
    }
  }

  updateThemeData() {
    db
        .collection('users')
        .doc(Constant.useruid)
        .collection('setting')
        .doc('themesetting')
        .set({'unlockTheme': Constant.unlockTheme});
  }
}
