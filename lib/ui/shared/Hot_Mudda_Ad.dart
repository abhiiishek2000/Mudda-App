

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mudda/ui/shared/AdHelper.dart';
import 'package:shimmer/shimmer.dart';

class HotMuddaAD extends StatefulWidget {
  const HotMuddaAD({Key? key}) : super(key: key);

  @override
  State<HotMuddaAD> createState() => _HotMuddaADState();
}

class _HotMuddaADState extends State<HotMuddaAD>  with AutomaticKeepAliveClientMixin {

  NativeAd? _ad;
  bool? isLoaded;

  @override
  bool get wantKeepAlive => true;


  @override
  void initState() {
    _ad = NativeAd(
      adUnitId: AdHelper.nativeHomeFeedAdUnitId,
      factoryId: 'mudda',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          print('Ad Loaded');
          isLoaded = true;
          setState(() {
          });
        },
        onAdImpression: (_) {
          print('Ad onAdImpression${_}');
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          // ad.dispose();
          isLoaded = false;
          setState(() {
          });
          print(
              'Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );
    _ad?.load();
    super.initState();
  }

  @override
  void dispose() {
    _ad!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const _shimmerGradient = LinearGradient(
      colors: [
        Color(0xFFFFFFFF),
        Color(0xFFEBEBF4),
        Color(0xFFFFFFFF),
      ],
      stops: [
        0.1,
        0.3,
        0.4,
      ],
      begin: Alignment(-1.0, -0.5),
      end: Alignment(1.0, 0.5),
      tileMode: TileMode.repeated,
    );
    return isLoaded==true? Container(
      alignment: Alignment.center,
      width: ScreenUtil().screenWidth,
      height: ScreenUtil().screenWidth,
      child: AdWidget(ad: _ad!),
    ): Shimmer(
        child: Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenWidth,
        color: Colors.white,
    ), gradient: _shimmerGradient);
  }
}
