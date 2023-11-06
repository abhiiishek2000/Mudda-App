import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get nativeHomeFeedAdUnitId {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-8256017943830665/2041953521';
      return 'ca-app-pub-8256017943830665/2041953521';

      //ca-app-pub-8256017943830665/2041953521 -production
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8256017943830665/6250774777';
    }
    throw UnsupportedError("Unsupported platform");
  }
  static String get nativeMuddebazzAdUnitId {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-8256017943830665/2041953521';
      return 'ca-app-pub-8256017943830665/1002272395';

      //ca-app-pub-8256017943830665/2041953521 -production
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8256017943830665/6250774777';
    }
    throw UnsupportedError("Unsupported platform");
  }


  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-8256017943830665/2041953521';
      return 'ca-app-pub-8256017943830665/7184537366';
      //ca-app-pub-8256017943830665/7184537366- Production
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8256017943830665/6382884131';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get fameIntersAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1224122391151794/6538106190';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1224122391151794/3915692145';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get funLinksNativeAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8256017943830665/9506840220';
      // return 'ca-app-pub-3940256099942544/2247696110';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8256017943830665/3599657402';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get followLinksNativeAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8256017943830665/6689105191';
      // return 'ca-app-pub-3940256099942544/2247696110';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8256017943830665/6233274197';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get exploreNativeAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8256017943830665/7342506035';
      // return 'ca-app-pub-3940256099942544/2247696110';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8256017943830665/3156804273';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get exploreFunLinksNativeAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8256017943830665/1628350206';
      // return 'ca-app-pub-3940256099942544/2247696110';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8256017943830665/7618793460';
    }
    throw UnsupportedError("Unsupported platform");
  }
}
