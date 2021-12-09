import 'dart:math';

import 'package:flutter/material.dart';

class FloatingDotGroup extends StatefulWidget {
  FloatingDotGroup({
    final Key? key,
    this.number = 25,
    this.direction = Direction.random,
    this.trajectory = Trajectory.random,
    this.size = DotSize.random,
    this.colors = Colors.primaries,
    this.opacity = .5,
    this.speed = DotSpeed.slow,
  }) : super(key: key);

  final int number;
  final Direction direction;
  final Trajectory trajectory;
  final DotSize size;
  final List<Color> colors;
  final double opacity;
  final DotSpeed speed;
  final random = Random();

  @override
  State<StatefulWidget> createState() => FloatingDotGroupState();
}

class FloatingDotGroupState extends State<FloatingDotGroup> {
  late double radius;
  late int time;

  List<Widget> buildDots() {
    final dots = <Widget>[];

    for (var i = 0; i < widget.number; i++) {
      if (widget.size == DotSize.small) {
        radius = widget.random.nextDouble() * 15 + 5;
      } else if (widget.size == DotSize.medium) {
        radius = widget.random.nextDouble() * 25 + 25;
      } else if (widget.size == DotSize.large) {
        radius = widget.random.nextDouble() * 50 + 50;
      } else if (widget.size == DotSize.random) {
        radius = widget.random.nextDouble() * 70 + 5;
      }
      if (widget.speed == DotSpeed.slow) {
        time = widget.random.nextInt(45) + 22;
      } else if (widget.speed == DotSpeed.medium) {
        time = widget.random.nextInt(30) + 15;
      } else if (widget.speed == DotSpeed.fast) {
        time = widget.random.nextInt(15) + 7;
      } else if (widget.speed == DotSpeed.mixed) {
        time = widget.random.nextInt(45) + 7;
      }
      dots.add(
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: FloatingDot(
            direction: widget.direction,
            trajectory: widget.trajectory,
            radius: radius,
            color: widget.colors[widget.random.nextInt(widget.colors.length)]
                .withOpacity(widget.opacity),
            time: time,
          ),
        ),
      );
    }
    return dots;
  }

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: buildDots(),
      ),
    );
  }
}

class FloatingDot extends StatefulWidget {
  const FloatingDot({
    required this.direction,
    required this.trajectory,
    required this.radius,
    required this.color,
    required this.time,
    final Key? key,
  }) : super(key: key);

  final Direction direction;
  final Trajectory trajectory;
  final double radius;
  final int time;
  final Color color;

  @override
  State<StatefulWidget> createState() => FloatingDotState();
}

class FloatingDotState extends State<FloatingDot>
    with SingleTickerProviderStateMixin {
  Random random = Random();
  late bool _vertical;
  late bool _inverseDir;
  late double _initialPosition;
  late double _destination;
  late double _start;
  late double _fraction;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    _fraction = 0.0;
    if (widget.direction == Direction.up) {
      _vertical = true;
      _inverseDir = false;
    } else {
      _vertical = random.nextBool();
      _inverseDir = random.nextBool();
    }
    _initialPosition = random.nextDouble();
    if (widget.trajectory == Trajectory.straight) {
      _destination = _initialPosition;
    } else {
      _destination = random.nextDouble();
    }
    _start = 150 * random.nextDouble();
    controller = AnimationController(
      duration: Duration(seconds: widget.time),
      vsync: this,
    );

    controller
      ..addListener(() {
        setState(() {
          _fraction = controller.value;
        });
      })
      ..repeat();
  }

  @override
  void didUpdateWidget(covariant final FloatingDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.direction != oldWidget.direction) {
      if (widget.direction == Direction.up) {
        _vertical = true;
        _inverseDir = false;
      } else {
        _vertical = random.nextBool();
        _inverseDir = random.nextBool();
      }
    }
    if (widget.trajectory != oldWidget.trajectory) {
      if (widget.trajectory == Trajectory.straight) {
        _destination = _initialPosition;
      } else {
        _destination = random.nextDouble();
      }
    }
    if (widget.time != oldWidget.time) {
      controller
        ..duration = Duration(seconds: widget.time)
        ..repeat();
    }
  }

  @override
  Widget build(final BuildContext context) {
    return CustomPaint(
      painter: DotPainter(
        vertical: _vertical,
        inverseDir: _inverseDir,
        initialPosition: _initialPosition,
        destination: _destination,
        radius: widget.radius,
        start: _start,
        fraction: _fraction,
        color: widget.color,
      ),
    );
  }
}

class DotPainter extends CustomPainter {
  DotPainter({
    required this.vertical,
    required this.inverseDir,
    required this.initialPosition,
    required this.destination,
    required this.radius,
    required this.start,
    required this.fraction,
    required this.color,
  }) : _paint = Paint() {
    _paint.color = color;
    diameter = radius * 2;
    distance = destination - initialPosition;
  }

  bool vertical;
  bool inverseDir;
  double initialPosition;
  double destination;
  double radius;
  double start;
  late double diameter;
  late double distance;
  double fraction;
  Color color;
  final Paint _paint;

  @override
  void paint(final Canvas canvas, final Size size) {
    var offset = Offset.zero;
    if (!vertical && inverseDir) {
      offset = Offset(
        -start - radius + (size.width + diameter + start) * fraction,
        size.height * (initialPosition + distance * fraction),
      );
    } else if (vertical && inverseDir) {
      offset = Offset(
        size.width * (initialPosition + distance * fraction),
        -start - radius + (size.height + diameter + start) * fraction,
      );
    } else if (!vertical && !inverseDir) {
      offset = Offset(
        size.width +
            start +
            radius -
            (size.width + diameter + start) * fraction,
        size.height * (initialPosition + distance * fraction),
      );
    } else if (vertical && !inverseDir) {
      offset = Offset(
        size.width * (initialPosition + distance * fraction),
        size.height +
            start +
            radius -
            (size.height + diameter + start) * fraction,
      );
    }

    canvas.drawCircle(offset, radius, _paint);
  }

  @override
  bool shouldRepaint(final CustomPainter oldDelegate) {
    return true;
  }
}

enum Direction {
  up,
  random,
}

enum Trajectory {
  straight,
  random,
}

enum DotSize {
  small,
  medium,
  large,
  random,
}

enum DotSpeed {
  slow,
  medium,
  fast,
  mixed,
}
