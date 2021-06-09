import 'dart:async';
import 'dart:math';

import 'package:notes/_internalPackages.dart';
import 'package:notes/screen/_screens.dart';

class MyLockScreen extends StatefulWidget {
  const MyLockScreen({
    required this.title,
    required this.onTap,
    required this.onDelTap,
    required this.enteredPassCode,
    required this.stream,
    required this.doneCallBack,
    this.onFingerTap,
    Key? key,
  }) : super(key: key);

  final Widget title;
  final KeyboardTapCallback onTap;
  final DeleteTapCallback onDelTap;
  final FingerTapCallback? onFingerTap;
  final String enteredPassCode;
  final Stream<bool> stream;
  final DoneCallBack doneCallBack;

  @override
  _MyLockScreenState createState() => _MyLockScreenState();
}

class _MyLockScreenState extends State<MyLockScreen>
    with SingleTickerProviderStateMixin {
  late StreamSubscription<bool> streamSubscription;
  late AnimationController controller;
  late Animation<double> animation;
  Key myKey = UniqueKey();

  @override
  void dispose() {
    super.dispose();
    streamSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    streamSubscription = widget.stream.listen(
      (isValid) {
        _showValidation(isValid);
      },
    );
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    final Animation<double> curve = CurvedAnimation(
      parent: controller,
      curve: ShakeCurve(),
    );
    // ignore: prefer_int_literals
    animation = Tween(begin: 0.0, end: 10.0).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            widget.doneCallBack('');
            controller.value = 0;
          });
        }
      })
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // passwordRow(),
            ShakeWidget(key: myKey, child: passwordRow()),
            keyPad(),
          ],
        ),
      ),
    );
  }

  void _showValidation(bool isValid) {
    if (!isValid) {
      controller.forward();
      myKey = UniqueKey();
    }
  }

  List<Widget> buildCircles(String enteredPassCode) {
    final list = <Widget>[];
    final size = animation.value;
    for (var i = 0; i < 4; ++i) {
      list.add(
        Container(
          margin: const EdgeInsets.all(8),
          child: Circle(
            isFilled: i < enteredPassCode.length,
            size: size,
          ),
        ),
      );
    }
    return list;
  }

  Widget passwordRow() => Column(
        children: [
          widget.title,
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buildCircles(widget.enteredPassCode),
          )
        ],
      );

  Widget keyPad() => Padding(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Keyboard(
          onKeyboardTap: widget.onTap,
          onDelTap: widget.onDelTap,
          onFingerTap: widget.onFingerTap,
        ),
      );

  @override
  void didUpdateWidget(MyLockScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stream != oldWidget.stream) {
      streamSubscription.cancel();
      streamSubscription = widget.stream.listen((isValid) {
        _showValidation(isValid);
      });
    }
  }
}

class ShakeCurve extends Curve {
  @override
  double transform(double t) => sin(t * 2.5 * pi).abs();
}

class ShakeWidget extends StatelessWidget {
  const ShakeWidget({
    required this.child,
    Key? key,
    this.duration = const Duration(milliseconds: 500),
    this.deltaX = 30,
    this.curve = Curves.bounceOut,
  }) : super(key: key);

  final Curve curve;
  final double deltaX;
  final Widget child;

  final Duration duration;

  /// convert 0-1 to 0-1-0
  double shake(double animation) =>
      2 * (0.5 - (0.5 - curve.transform(animation)).abs());

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        key: key,
        tween: Tween(begin: 0, end: 1),
        duration: duration,
        builder: (context, animation, child) => Transform.translate(
          offset: Offset(
              deltaX * shake(animation), deltaX * shake(animation) * 0.4),
          child: child,
        ),
        child: child,
      );
}
