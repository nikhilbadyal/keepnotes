import 'package:flutter/material.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/Navigations.dart';

class DoubleBackToCloseWidget extends StatefulWidget {
  const DoubleBackToCloseWidget({required this.child});

  final Widget child;

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
        onWillPop: () async {
          if (ModalRoute.of(context)!.settings.name! == '/lock' ||
              ModalRoute.of(context)!.settings.name! == '/setpass') {
            await navigate(ModalRoute.of(context)!.settings.name!, context,
                NotesRoutes.homeScreen);
            return Future.value(true);
          } else {
            return Future.value(true);
          }
        },
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }
}
