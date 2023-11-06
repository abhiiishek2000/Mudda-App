import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/color.dart';

class LeaderBoardLoadingView extends StatelessWidget {
  const LeaderBoardLoadingView({Key? key}) : super(key: key);

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
    return Shimmer(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 75,
            width: 70,
            child: Column(
              children: [
                const SizedBox(
                  height: 18,
                ),
                Container(
                  width: 20,
                  height: 12,
                  color: white,
                )
              ],
            ),
            decoration: BoxDecoration(
                color: white,
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                border: Border.all(color: Colors.white)),
          ),
          Container(
            height: 30,
            width: 70,
            child: Center(
              child:   Container(
                width: 20,
                height: 12,
                color: white,
              ),
            ),
            decoration: BoxDecoration(
              color: white,
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              border: Border.all(
                color: const Color(0xFF555555),
              ),
            ),
          )
        ],
      ),
      gradient: _shimmerGradient,
    );
  }
}
