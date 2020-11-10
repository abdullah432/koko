import 'package:flutter/material.dart';
import 'package:kuku/screens/imageview.dart';

class Navigation {
  static void navigateTo(context, page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  static void navigateToPhotoView(
      {@required context, @required images, @required index}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyPhotoView(
                  galleryItems: images,
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  initialIndex: index,
                  scrollDirection: Axis.horizontal,
                )));
  }
}
