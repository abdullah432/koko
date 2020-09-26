import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:firebase_admob/firebase_admob.dart';

class MyCustomAdmob {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    testDevices: <String>[], // Android emulators are considered test devices
  );

  // BannerAd bannerAd() {
  //   return BannerAd(
  //     adUnitId: BannerAd.testAdUnitId,
  //     size: AdSize.smartBanner,
  //     targetingInfo: targetingInfo,
  //     listener: (MobileAdEvent event) {
  //       print("BannerAd event is $event");
  //     },
  //   );
  // }

  InterstitialAd interstitialAdMob() {
    return InterstitialAd(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      // targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
  }

  InterstitialAd interstitialVideoAdMob() {
    return InterstitialAd(
      adUnitId: 'ca-app-pub-3940256099942544/8691691433',
      // targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
  }
}
