import 'package:flutter/material.dart';
import 'package:notes/model/_model.dart';
import 'package:notes/screen/_screens.dart';
import 'package:notes/widget/_widgets.dart';

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
