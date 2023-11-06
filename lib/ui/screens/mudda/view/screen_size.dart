import 'package:flutter/widgets.dart';

class SizeConfig {
  static double? _screenWidth;
  static double? screenWidth;
  static double? screenHeight;
  static double? _screenHeight;
  static double _blockSizeHorizontal = 0;
  static double _blockSizeVertical = 0;

  static bool? portrait;
  static late double textMultiplier;
  static double? imageMultiplier;
  static late double heightMultiplier;
  static late double widthMultiplier;

  void init(BoxConstraints constraints,
      Orientation orientation,) {
    if (orientation == Orientation.portrait) {
      portrait = true;
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
    } else {
      portrait = false;
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
    }
    _blockSizeHorizontal = _screenWidth! / 100;
    _blockSizeVertical = _screenHeight! / 100;

    screenWidth = _screenWidth;
    screenHeight = _screenHeight;
    textMultiplier = _blockSizeVertical;
    imageMultiplier = _blockSizeHorizontal;
    heightMultiplier = _blockSizeVertical;
    widthMultiplier = _blockSizeHorizontal;
  }
}
