import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImagesGridView extends StatelessWidget {
  List<Asset> images;
  ImagesGridView({@required this.images});
  @override
  Widget build(BuildContext context) {
    if (images != null)
      return Padding(
        padding: const EdgeInsets.only(left: 14.0, right: 14.0),
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(images.length, (index) {
            Asset asset = images[index];
            return Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: AssetThumb(
                  quality: 100,
                  asset: asset,
                  width: 90,
                  height: 90,
                ),
              ),
            );
          }),
        ),
      );
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
