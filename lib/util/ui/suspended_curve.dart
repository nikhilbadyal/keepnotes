import 'dart:ui';

import 'package:notes/_internal_packages.dart';

class SuspendedCurve extends Curve {
  const SuspendedCurve(
    this.startingPoint, {
    this.curve = Curves.easeOutCubic,
  });

  final double startingPoint;

  final Curve curve;

  @override
  double transform(final double t) {
    if (t < startingPoint) {
      return t;
    }

    if (t == 1.0) {
      return t;
    }

    final curveProgress = (t - startingPoint) / (1 - startingPoint);
    final transformed = curve.transform(curveProgress);
    return lerpDouble(startingPoint, 1, transformed)!;
  }
}
