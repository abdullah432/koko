import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kuku/utils/constant.dart';

class PhotoGridView extends StatelessWidget {
  final images;
  final void Function(int index) onTap;
  const PhotoGridView({@required this.images, @required this.onTap, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return images.length != 0
        ? GridView.count(
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 15.0,
            mainAxisSpacing: 15.0,
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            crossAxisCount: images.length > 1 ? 2 : 1,
            shrinkWrap: true,
            children: List.generate(images.length, (index) {
              return GestureDetector(
                onTap: () => onTap(index),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: images[index],
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Container(
                              child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Constant.selectedColor),
                          value: downloadProgress.progress,
                        ),
                      )),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )),
              );
            }),
          )
        : Container(height: 0.0);
  }
}
