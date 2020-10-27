import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';

class FacebookNativeInterstialAd extends StatelessWidget {
  double height;
  double width;
  Color color;
  FacebookNativeInterstialAd(
      {@required this.height, @required this.width, @required this.color, Key key})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: FacebookNativeAd(
        placementId: "3663243730352300_3663359137007426",
        adType: NativeAdType.NATIVE_AD,
        width: width,
        height: height,
        backgroundColor: color,
        titleColor: Colors.white,
        descriptionColor: Colors.white,
        buttonColor: color,
        buttonTitleColor: Colors.white,
        buttonBorderColor: Colors.white,
        keepAlive:
            true, //set true if you do not want adview to refresh on widget rebuild
        keepExpandedWhileLoading:
            true, // set false if you want to collapse the native ad view when the ad is loading
        expandAnimationDuraion:
            300, //in milliseconds. Expands the adview with animation when ad is loaded
        listener: (result, value) {
          print("Native Ad: $result --> $value");
        },
      ),
    );
  }
}
