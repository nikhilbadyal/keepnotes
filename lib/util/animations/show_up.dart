import 'dart:async';

import 'package:flutter/material.dart';

enum SlideFromSlide { top, bottom, left, right }

class ShowUpTransition extends StatefulWidget {
  const ShowUpTransition({
    required this.forward,
    required this.child,
    required this.duration,
    this.delay = Duration.zero,
    this.slideSide = SlideFromSlide.left,
    final Key? key,
  }) : super(key: key);

  final Widget child;

  final Duration duration;

  final Duration delay;

  final bool forward;

  final SlideFromSlide slideSide;

  @override
  _ShowUpTransitionState createState() => _ShowUpTransitionState();
}

class _ShowUpTransitionState extends State<ShowUpTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _animOffset;

  List<Offset> slideSides = [
    const Offset(-0.20, 0),
    const Offset(0.20, 0),
    const Offset(0, 0.20),
    const Offset(0, -0.20),
  ];
  late Offset selectedSlide;

  @override
  void initState() {
    super.initState();
    _animController =
        AnimationController(vsync: this, duration: widget.duration);
    switch (widget.slideSide) {
      case SlideFromSlide.left:
        selectedSlide = slideSides[0];
        break;
      case SlideFromSlide.right:
        selectedSlide = slideSides[1];
        break;
      case SlideFromSlide.bottom:
        selectedSlide = slideSides[2];
        break;
      case SlideFromSlide.top:
        selectedSlide = slideSides[3];
        break;
    }
    _animOffset = Tween<Offset>(begin: selectedSlide, end: Offset.zero).animate(
      CurvedAnimation(
        curve: Curves.fastLinearToSlowEaseIn,
        parent: _animController,
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    Timer(widget.delay, () {
      if (widget.forward) {
        if (mounted) {
          _animController.forward();
        }
      } else {
        if (mounted) {
          _animController.reverse();
        }
      }
    });
    return widget.forward
        ? FadeTransition(
            opacity: _animController,
            child: SlideTransition(
              position: _animOffset,
              child: widget.child,
            ),
          )
        : Container();
  }
}
