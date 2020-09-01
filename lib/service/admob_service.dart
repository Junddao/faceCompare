import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

class AdMobService {
  String getAdMobID() {
    if (Platform.isIOS) {
    } else if (Platform.isAndroid) {
      return "ca-app-pub-9695790043722201~1248801288";
    }
    return null;
  }

  String getBannerAdID() {
    if (Platform.isIOS) {
    } else if (Platform.isAndroid) {
      // return "ca-app-pub-9695790043722201/8889394257";
    }
    return null;
  }

  String getInterstitialAdId() {
    if (Platform.isIOS) {
    } else if (Platform.isAndroid) {
      // my admob
      return "ca-app-pub-9695790043722201/8889394257";
      // test admob
      // return "ca-app-pub-3940256099942544/1033173712";
    }
    return null;
  }

  InterstitialAd getNewInterstitial() {
    return InterstitialAd(
      adUnitId: getInterstitialAdId(),
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
  }
}
