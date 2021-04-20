import 'package:flutter/material.dart';
import 'package:notes/model/Note.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/DoubleBackToClose.dart';

enum ScreenTypes {
  Hidden,
  Lock,
  Setpass,
  Home,
  Archive,
  Backup,
  Trash,
  AboutMe,
  Settings,
  Suggestions,
}

typedef actionFunction = void Function(
    BuildContext context, Note note, onTapCallback);
typedef onTapCallback = void Function(BuildContext context, Note note);
typedef BackPresAction = Future<bool> Function();

abstract class TopWidgetBase extends StatefulWidget {
  const TopWidgetBase({Key? key}) : super(key: key);

  Widget get body;

  Widget get myDrawer;

  MyAppBar? get appBar;

  Widget? get floatingActionButton;

  @override
  _TopWidgetBaseState createState() => _TopWidgetBaseState();
}

class _TopWidgetBaseState extends State<TopWidgetBase> {
  @override
  Widget build(BuildContext context) {
    return DoubleBackToCloseWidget(
      child: Scaffold(
        appBar: widget.appBar,
        drawer: widget.myDrawer,
        body: widget.body,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        // bottomSheet: bottomSheet,
      ),
    );
  }
}
