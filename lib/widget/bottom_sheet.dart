//29-12-2021 09:28 PM

// ignore_for_file: invalid_use_of_protected_member

import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';
import 'package:notes/util/ui/suspended_curve.dart';

class BottomSheetRoute<T> extends PopupRoute<T> {
  BottomSheetRoute({
    required this.child,
    this.backgroundColor,
    this.elevation = 0,
    this.shape = const RoundedRectangleBorder(),
    this.clipBehavior = Clip.none,
    this.maintainState = true,
    this.enableDismiss = true,
    this.enableGestures = true,
  });

  final Widget child;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final bool enableDismiss;
  final bool enableGestures;

  @override
  Color get barrierColor => Colors.black54;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    final BuildContext context,
    final Animation<double> animation,
    final Animation<double> secondaryAnimation,
  ) {
    return _BottomSheetBase(
      route: this,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      enableGestures: enableGestures,
      child: child,
    );
  }

  @override
  final bool maintainState;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 250);

  @override
  bool get barrierDismissible => enableDismiss;

  @override
  Curve get barrierCurve => decelerateEasing;
}

class _BottomSheetBase extends StatefulWidget {
  const _BottomSheetBase({
    required this.child,
    required this.route,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.enableGestures = true,
  });

  final Widget child;
  final BottomSheetRoute route;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final bool enableGestures;

  @override
  _BottomSheetBaseState createState() => _BottomSheetBaseState();
}

class _BottomSheetBaseState extends State<_BottomSheetBase> {
  final GlobalKey _childKey = GlobalKey();
  Curve _curve = decelerateEasing;

  double get _childHeight {
    final box = _childKey.currentContext!.findRenderObject()! as RenderBox;
    return box.size.height;
  }

  @override
  Widget build(final BuildContext context) {
    return AnimatedBuilder(
      animation: widget.route.animation!,
      builder: (final context, final _) {
        return LayoutBuilder(
          builder: (final context, final constraints) {
            const shortestSide = 480;
            final roundedShortestSide = (shortestSide / 10).round() * 10;

            final _constraints = BoxConstraints(
              maxWidth: roundedShortestSide.toDouble(),
              maxHeight:
                  min(600.0 + context.viewInsets.bottom, context.mSize.height),
            );
            const _useDesktopLayout = false;

            return GestureDetector(
              onVerticalDragStart: !_useDesktopLayout && widget.enableGestures
                  ? (final details) {
                      _curve = Curves.linear;
                    }
                  : null,
              onVerticalDragUpdate: !_useDesktopLayout && widget.enableGestures
                  ? (final details) {
                      widget.route.controller!.value -=
                          details.primaryDelta! / _childHeight;
                    }
                  : null,
              onVerticalDragEnd: !_useDesktopLayout && widget.enableGestures
                  ? (final details) {
                      _curve = SuspendedCurve(
                        widget.route.animation!.value,
                        curve: decelerateEasing,
                      );

                      if (details.primaryVelocity! > 350) {
                        final _closeSheet =
                            details.velocity.pixelsPerSecond.dy > 0;
                        if (_closeSheet) {
                          widget.route.navigator?.pop();
                        } else {
                          widget.route.controller!.fling();
                        }

                        return;
                      }

                      if (widget.route.controller!.value > 0.5) {
                        widget.route.controller!.fling();
                      } else {
                        widget.route.navigator?.pop();
                      }
                    }
                  : null,
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: decelerateEasing,
                alignment: _useDesktopLayout
                    ? Alignment.center
                    : Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.only(
                    top: _useDesktopLayout ? 16 : 48,
                  ),
                  constraints: _constraints,
                  child: Builder(
                    builder: (final context) {
                      final Widget commonChild = Material(
                        key: _childKey,
                        color: widget.backgroundColor,
                        shape: _useDesktopLayout
                            ? context.theme.dialogTheme.shape
                            : widget.shape ??
                                context.theme.bottomSheetTheme.shape,
                        elevation: widget.elevation ?? 1,
                        clipBehavior: widget.clipBehavior ?? Clip.antiAlias,
                        child: AnimatedPadding(
                          duration: const Duration(milliseconds: 300),
                          curve: decelerateEasing,
                          padding: EdgeInsets.only(
                            bottom:
                                !_useDesktopLayout ? context.padding.bottom : 0,
                          ),
                          child: MediaQuery(
                            data: context.mediaQuery.copyWith(
                              viewInsets: context.viewInsets.copyWith(
                                bottom: _useDesktopLayout
                                    ? 0
                                    : context.viewInsets.bottom,
                              ),
                            ),
                            child: MediaQuery.removePadding(
                              context: context,
                              child: widget.child,
                            ),
                          ),
                        ),
                      );

                      if (_useDesktopLayout) {
                        return FadeTransition(
                          opacity: CurvedAnimation(
                            curve: Curves.easeOut,
                            parent: widget.route.animation!,
                          ),
                          child: commonChild,
                        );
                      } else {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              curve: _curve,
                              parent: widget.route.animation!,
                            ),
                          ),
                          child: commonChild,
                        );
                      }
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
