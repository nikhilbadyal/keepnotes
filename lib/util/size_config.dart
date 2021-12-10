//24-11-2021 12:46 PM

import 'package:flutter/widgets.dart';
import 'package:notes/_internal_packages.dart';

class SizeConfig {
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _blockWidth = 0;
  static late double _blockHeight = 0;

  static late double textMultiplier;
  static late double imageSizeMultiplier;
  static late double _heightMultiplier;
  static late double widthMultiplier;
  static late bool isPortrait = true;
  static late bool isMobilePortrait = false;

  void init(final BoxConstraints constraints, final Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }
    _blockWidth = _screenWidth / 100;
    _blockHeight = _screenHeight / 100;
    textMultiplier = _blockHeight;
    imageSizeMultiplier = _blockWidth;
    _heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;
    debugPrint(toString());
  }

  @override
  String toString() {
    return 'Width: $_screenWidth \nHeight: $_screenHeight \nText: $textMultiplier '
        '\nImage: $imageSizeMultiplier \nHeightFactor: $_heightMultiplier '
        '\nWidthFactor: $widthMultiplier';
  }
}

double get screenHeight => SizeConfig._screenHeight;

double get textMultiplier => SizeConfig.textMultiplier;

double get imageSizeMultiplier => SizeConfig.imageSizeMultiplier;

double get heightMultiplier => SizeConfig._heightMultiplier;

double get widthMultiplier => SizeConfig.widthMultiplier;
