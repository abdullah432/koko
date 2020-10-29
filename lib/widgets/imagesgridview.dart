import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImagesGridView extends StatelessWidget {
  final void Function(int index) onRemove;
  List<Asset> images;
  ImagesGridView({
    @required this.images,
    @required this.onRemove,
  });
  @override
  Widget build(BuildContext context) {
    if (images != null)
      return Padding(
          padding: const EdgeInsets.only(left: 14.0, right: 14.0),
          child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                images.length,
                (index) {
                  Asset asset = images[index];
                  return Stack(children: <Widget>[
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: AssetThumb(
                          quality: 100,
                          asset: asset,
                          width: 90,
                          height: 90,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      top: 0.0,
                      child: GestureDetector(
                          onTap: () => this.onRemove(index),
                          child: Icon(FlutterIcons.cross_ent, color: Colors.white,)),
                    )
                  ]);
                },
              )));
    else
      return Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Text(
          'No Image selected',
          style: TextStyle(color: Colors.white),
        ),
      );
  }
}
