import 'package:flutter/material.dart';
import 'package:notes/util/AppRoutes.dart';

typedef BackPresAction = Future<bool> Function();

class DoubleBackToCloseWidget extends StatefulWidget {
  const DoubleBackToCloseWidget({required this.child});

  // const DoubleBackToCloseWidget({required this.child, this.backPresAction});

  final Widget child;

  // final BackPresAction? backPresAction;

  static const exitTimeInMillis = 1500;

  @override
  _DoubleBackToCloseWidgetState createState() =>
      _DoubleBackToCloseWidgetState();
}

class _DoubleBackToCloseWidgetState extends State<DoubleBackToCloseWidget> {
  @override
  Widget build(BuildContext context) {
    //debugPrint('double back building 34');
    final _isAndroid = Theme.of(context).platform == TargetPlatform.android;
    if (_isAndroid) {
      return WillPopScope(
        onWillPop: defaultBackPress,
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }

  Future<bool> defaultBackPress() async {
    if (ModalRoute.of(context)!.settings.name! == '/lock' ||
        ModalRoute.of(context)!.settings.name! == '/setpass') {
      Navigator.of(context)
          .popUntil((route) => route.settings.name == NotesRoutes.homeScreen);
      return Future.value(true);
    } else {
      return Future.value(true);
    }
  }
}
