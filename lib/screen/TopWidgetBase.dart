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

  Widget? body(BuildContext context);

  Widget? myDrawer(BuildContext context);

  MyAppBar? appBar(BuildContext context);

  Widget? floatingActionButton(BuildContext context);

  @override
  _TopWidgetBaseState createState() => _TopWidgetBaseState();
}

class _TopWidgetBaseState extends State<TopWidgetBase> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DoubleBackToCloseWidget(
        child: Scaffold(
          appBar: widget.appBar(context),
          drawer: widget.myDrawer(context),
          body: widget.body(context),
          floatingActionButton: widget.floatingActionButton(context),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          // bottomSheet: bottomSheet,
        ),
      ),
    );
  }
}
