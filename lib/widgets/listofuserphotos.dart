import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ListOfUserPhotos extends StatelessWidget {
  final void Function(int index) onTap;
  final List<dynamic> images;
  const ListOfUserPhotos({@required this.images, @required this.onTap, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, position) {
          return GestureDetector(
            onTap: () => this.onTap(position),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: images[position],
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Container(
                            height: 200,
                            width: 120,
                            child: Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress),
                            )),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                )),
          );
        },
      ),
    );
  }
}
