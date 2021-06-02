import 'package:flutter/material.dart';
import 'package:notes/model/Note.dart';
import 'package:notes/screen/topWidget/AppBar.dart';
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

typedef ActionFunction = void Function(
    BuildContext context, Note note, OnTapCallback);
typedef OnTapCallback = void Function(BuildContext context, Note note);
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
  Widget build(BuildContext context) => DoubleBackToCloseWidget(
        child: Scaffold(
          appBar: widget.appBar(context),
          drawer: widget.myDrawer(context),
          body: widget.body(context),
          floatingActionButton: widget.floatingActionButton(context),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        ),
      );
}
