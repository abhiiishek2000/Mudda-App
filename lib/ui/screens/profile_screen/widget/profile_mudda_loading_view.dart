import 'package:flutter/material.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:shimmer/shimmer.dart';

class ProfileMuddaLoadingView extends StatelessWidget {
  const ProfileMuddaLoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
    return Shimmer(
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        height: height * 0.15,
        width: width,
        color: white,
      ),
      gradient: _shimmerGradient,
    );
  }
}
