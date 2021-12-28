//24-11-2021 12:46 PM

import 'package:flutter/widgets.dart';
import 'package:notes/_internal_packages.dart';

class SizeConfig {
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _blockWidth = 0;
  static late double _blockHeight = 0;

  static late double _textMultiplier;
  static late double _imageSizeMultiplier;
  static late double _heightMultiplier;
  static late double _widthMultiplier;
  static late bool _isPortrait = true;

  void init(final BoxConstraints constraints, final Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      _isPortrait = true;
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      _isPortrait = false;
    }
    _blockWidth = _screenWidth / 100;
    _blockHeight = _screenHeight / 100;
    _textMultiplier = _blockHeight;
    _imageSizeMultiplier = _blockWidth;
    _heightMultiplier = _blockHeight;
    _widthMultiplier = _blockWidth;
  }

  @override
  String toString() {
    return 'Width: $_screenWidth \nHeight: $_screenHeight '
        '\nTextFactor: $textMultiplier '
        '\nImageFactor: $imageSizeMultiplier \nHeightFactor:'
        ' $_heightMultiplier '
        '\nWidthFactor: $widthMultiplier';
  }
}

double get screenHeight => SizeConfig._screenHeight;

double get textMultiplier => SizeConfig._textMultiplier;

double get imageSizeMultiplier => SizeConfig._imageSizeMultiplier;

double get heightMultiplier => SizeConfig._heightMultiplier;

double get widthMultiplier => SizeConfig._widthMultiplier;

bool get isPotrait => SizeConfig._isPortrait;
