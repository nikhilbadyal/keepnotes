import 'package:flutter/material.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/Languages/Languages.dart';
import 'package:notes/util/Utilites.dart';

typedef BackPresAction = Future<bool> Function();

class DoubleBackToCloseWidget extends StatefulWidget {
  const DoubleBackToCloseWidget({required this.child});

  final Widget child;

  static const exitTimeInMillis = 1500;

  @override
  _DoubleBackToCloseWidgetState createState() =>
      _DoubleBackToCloseWidgetState();
}

class _DoubleBackToCloseWidgetState extends State<DoubleBackToCloseWidget> {
  int _lastTimeBackButtonWasTapped = 0;

  @override
  Widget build(BuildContext context) {
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
    final _currentTime = DateTime.now().millisecondsSinceEpoch;
    if ((_currentTime - _lastTimeBackButtonWasTapped) <
        DoubleBackToCloseWidget.exitTimeInMillis) {
      return Future.value(true);
    } else {
      _lastTimeBackButtonWasTapped = DateTime.now().millisecondsSinceEpoch;
      if (ModalRoute.of(context)!.settings.name! == '/lock' ||
          ModalRoute.of(context)!.settings.name! == '/setpass') {
        Navigator.of(context)
            .popUntil((route) => route.settings.name == NotesRoutes.homeScreen);
        return Future.value(true);
      } else if (ModalRoute.of(context)!.settings.name! ==
          NotesRoutes.homeScreen) {
        Utilities.showSnackbar(context, Languages.of(context).doubleBackToExit,
            duration: const Duration(
                milliseconds: DoubleBackToCloseWidget.exitTimeInMillis - 10));
        return Future.value(false);
      } else {
        return Future.value(true);
      }
    }
  }
}
