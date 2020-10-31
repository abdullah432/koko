import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kuku/utils/constant.dart';
import 'package:kuku/widgets/nonpremiumcontainer.dart';
import 'package:kuku/widgets/premiumcontainer.dart';

class ImageSlider extends StatelessWidget {
  final List<dynamic> imageList;
  ImageSlider({@required this.imageList});
  @override
  Widget build(BuildContext context) {
    return imageList != null && imageList.length > 0 ? carouselSlider() : Constant.primiumThemeSelected
        ? PremiumContainer(
            gradient: Constant.selectedGradient,
            child: SizedBox.expand(),
          )
        : NonPremiumContainer(
            color: Constant.selectedColor,
            child: SizedBox.expand(),
          );
  }

  Widget carouselSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        // height: 350,
        // aspectRatio: 3/2,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 7),
        aspectRatio: 16/9,
      ),
      items: imageList
          .map((item) => Container(
            color: Colors.black54,
                child: Center(
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      width: 1000,
                  imageUrl: item,
                  placeholder: (context, url) => const SpinKitWave(
                      color: Colors.black, type: SpinKitWaveType.center),
                )
                    // Image.network(
                    //   item,
                    //   fit: BoxFit.fill,
                    //   width: 1000,
                    // ),
                    ),
              ))
          .toList(),
    );
  }
}
