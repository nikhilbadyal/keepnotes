import 'package:flutter/material.dart';
import 'package:notes/model/note.dart';
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

abstract class TopWidgetBase extends StatelessWidget {
  const TopWidgetBase({Key? key}) : super(key: key);

  Widget get body;

  Widget get myDrawer;

  MyAppBar? get appBar;

  Widget? get floatingActionButton;

  // Widget get bottomNavigationBar;
  // Widget get bottomSheet;

  @override
  Widget build(BuildContext context) {
    return DoubleBackToCloseWidget(
      child: Scaffold(
        appBar: appBar,
        drawer: myDrawer,
        body: body,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        // bottomSheet: bottomSheet,
      ),
    );
  }
}
