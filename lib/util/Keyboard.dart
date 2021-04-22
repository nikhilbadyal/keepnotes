import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes/main.dart';
import 'package:notes/util/AppConfiguration.dart';

typedef KeyboardTapCallback = void Function(String text);
typedef DeleteTapCallback = void Function();
typedef FingerTapCallback = void Function();
typedef DoneCallBack = void Function(String text);
typedef DoneEntered = Future<void> Function(String enteredPassCode);

class Keyboard extends StatelessWidget {
  Keyboard(
      {Key? key,
      required this.onKeyboardTap,
      required this.onDelTap,
      this.onFingerTap})
      : super(key: key);

  final KeyboardTapCallback onKeyboardTap;
  final DeleteTapCallback onDelTap;
  final FingerTapCallback? onFingerTap;
  final List<String> keyBoardItem = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '-1',
    '0',
    '-1'
  ];

  Widget _buildDigit(String text) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              onKeyboardTap(text);
            },
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    text,
                    semanticsLabel: text,
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExtra(Widget widget, DeleteTapCallback? onDelTap) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              onDelTap!();
            },
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: widget,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlign(
      children: List.generate(12, (index) {
        return index == 9 || index == 11
            ? index == 9
                ? onFingerTap == null || !lockChecker.bioAvailable
                    ? Container()
                    : _buildExtra(
                        const Icon(Icons.fingerprint_outlined), onFingerTap)
                : _buildExtra(const Icon(Icons.backspace_outlined), onDelTap)
            : _buildDigit(
                keyBoardItem[index],
              );
      }),
    );
  }
}

class CustomAlign extends StatelessWidget {
  const CustomAlign({Key? key, required this.children}) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(25),
      children: children
          .map(
            (e) => SizedBox(
              width: 5,
              height: 5,
              child: e,
            ),
          )
          .toList(),
    );
  }
}

class Circle extends StatefulWidget {
  const Circle({Key? key, required this.isFilled}) : super(key: key);

  final bool isFilled;

  @override
  _CircleState createState() => _CircleState();
}

class _CircleState extends State<Circle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: widget.isFilled
            ? selectedAppTheme == AppTheme.Light
                ? selectedPrimaryColor
                : Colors.white
            : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
            color: selectedAppTheme == AppTheme.Light
                ? selectedPrimaryColor
                : Colors.white,
            width: 2),
      ),
    );
  }
}

class ShakeCurve extends Curve {
  @override
  double transform(double t) {
    return sin(t * 2.5 * pi).abs();
  }
}
