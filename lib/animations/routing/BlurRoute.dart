import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlurPageRoute<T> extends PageRoute<T>
    with MaterialRouteTransitionMixin<T> {
  BlurPageRoute(
      {required this.builder,
      this.duration = const Duration(milliseconds: 500),
      this.keepState = false,
      this.blurStrength = 0,
      RouteSettings settings = const RouteSettings(),
      this.maintainState = true,
      bool fullscreenDialog = false,
      this.animationCurve = Curves.fastLinearToSlowEaseIn,
      this.opaque = false,
      this.slideOffset = const Offset(0, 10),
      this.useCardExit = true,
      this.backdropColor = Colors.transparent})
      : super(settings: settings, fullscreenDialog: fullscreenDialog);

  Duration duration;
  bool keepState;
  double blurStrength;
  Curve animationCurve;
  Offset slideOffset;
  bool useCardExit;
  Color backdropColor;

  final WidgetBuilder builder;

  @override
  Widget buildContent(BuildContext context) => builder(context);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (animation.status == AnimationStatus.reverse && !useCardExit) {
      return BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: blurStrength * animation.value,
            sigmaY: blurStrength * animation.value),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    } else {
      return SlideTransition(
        position: CurvedAnimation(
          parent: animation,
          curve: animationCurve,
        ).drive(
          Tween<Offset>(
            begin: slideOffset,
            end: const Offset(0, 0),
          ),
        ),
        child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: blurStrength * animation.value,
                sigmaY: blurStrength * animation.value),
            child: child),
      );
    }
  }

  @override
  final bool maintainState;

  @override
  Duration get transitionDuration => duration;

  @override
  Color get barrierColor => backdropColor;

  @override
  bool opaque;
}
