import 'package:flutter/material.dart';
import 'package:notes/app.dart';
import 'package:notes/model/note.dart';
import 'package:notes/screen/AboutMeScreen.dart';
import 'package:notes/screen/BackupRestore.dart';
import 'package:notes/screen/SettingsScreen.dart';
import 'package:notes/screen/TopWidgetBase.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/Body.dart';
import 'package:notes/widget/FloatingActionButton.dart';
import 'package:notes/widget/HomeBody.dart';
import 'package:notes/widget/MyDrawer.dart';

typedef slidableActions = Function(Note note, BuildContext context);
typedef actionGen = Widget Function(Note note, BuildContext context);

class ScreenContainer extends TopWidgetBase {
  const ScreenContainer({Key? key, required this.topScreen}) : super(key: key);
  final ScreenTypes topScreen;

  @override
  Widget get myDrawer {
    return MyDrawer();
  }

  @override
  MyAppBar? get appBar {
    switch (topScreen) {
      case ScreenTypes.Hidden:
        return const MyAppBar(
          title: Text('Hidden'),
        );
      case ScreenTypes.Home:
        return const MyAppBar(
          title: Text('Notes'),
        );

      case ScreenTypes.Archive:
        return const MyAppBar(
          title: Text('Archive'),
        );

      case ScreenTypes.Backup:
        return const MyAppBar(
          title: Text('Backup and Restore'),
        );

      case ScreenTypes.Trash:
        return const MyAppBar(
          title: Text('Trash'),
        );

      case ScreenTypes.AboutMe:
        return const MyAppBar(
          title: Text('About'),
          // TODO add attribution
          /*appBarWidget: IconButton(
              icon: const Icon(TablerIcons.license, color: Colors.green),
              onPressed: () {
                const LicensePage(
                  applicationName: 'My Notes',
                );
              },
            )*/
        );

      case ScreenTypes.Settings:
        return const MyAppBar(
          title: Text('Settings'),
        );
      default:
        return null;
    }
  }

  @override
  Widget? get floatingActionButton {
    switch (topScreen) {
      case ScreenTypes.Hidden:
        return const Fab(NoteState.hidden);
      case ScreenTypes.Archive:
        return const Fab(NoteState.archived);
      case ScreenTypes.Trash:
        return const TrashFab();
      case ScreenTypes.Home:
        return const Fab(NoteState.unspecified);
      default:
        return null;
    }
  }

  @override
  Widget get body {
    switch (topScreen) {
      case ScreenTypes.Backup:
        return const BackUpScreenHelper();

      case ScreenTypes.AboutMe:
        return const AboutMe();

      case ScreenTypes.Settings:
        return const SettingsScreenHelper();

      case ScreenTypes.Lock:
        return const ErrorScreen();

      case ScreenTypes.Setpass:
        return const ErrorScreen();

      case ScreenTypes.Home:
        final primary = getPrimary(topScreen);
        final secondary = getSecondary(topScreen);
        return HomeBody(
          primary: primary,
          secondary: secondary,
        );

      default:
        final notesType = getNotesType(topScreen);
        final primary = getPrimary(topScreen);
        final secondary = getSecondary(topScreen);
        return Body(
          fromWhere: notesType,
          primary: primary,
          secondary: secondary,
        );
    }
  }

  NoteState getNotesType(ScreenTypes topScreen) {
    switch (topScreen) {
      case ScreenTypes.Hidden:
        return NoteState.hidden;

      case ScreenTypes.Archive:
        return NoteState.archived;

      case ScreenTypes.Trash:
        return NoteState.deleted;

      default:
        return NoteState.unspecified;
    }
  }

  List<Widget> homePrimary(Note note, BuildContext context) {
    final actionList = <Widget>[];
    actionList.add(
      Utilities.hideAction(context, note),
    );
    actionList.add(
      Utilities.archiveAction(context, note),
    );
    return actionList;
  }

  List<Widget> homeSecondary(Note note, BuildContext context) {
    final actionList = <Widget>[];
    actionList.add(
      Utilities.copyAction(context, note),
    );
    actionList.add(
      Utilities.trashAction(context, note),
    );
    return actionList;
  }

  List<Widget> hiddenPrimary(Note note, BuildContext context) {
    final actionList = <Widget>[];
    actionList.add(
      Utilities.unHideAction(context, note),
    );
    return actionList;
  }

  List<Widget> hiddenSecondary(Note note, BuildContext context) {
    final actionList = <Widget>[];
    actionList.add(
      Utilities.trashAction(context, note),
    );
    return actionList;
  }

  List<Widget> archivePrimary(Note note, BuildContext context) {
    final actionList = <Widget>[];
    actionList.add(
      Utilities.hideAction(context, note),
    );
    actionList.add(
      Utilities.unArchiveAction(context, note),
    );
    return actionList;
  }

  List<Widget> archiveSecondary(Note note, BuildContext context) {
    final actionList = <Widget>[];
    actionList.add(
      Utilities.copyAction(context, note),
    );
    actionList.add(
      Utilities.trashAction(context, note),
    );
    return actionList;
  }

  List<Widget> trashSecondary(Note note, BuildContext context) {
    final actionList = <Widget>[];
    debugPrint(myNotes.lockChecker.directlyDelete.toString());

    actionList.add(
      Utilities.deleteAction(context, note,
          shouldAsk: myNotes.lockChecker.directlyDelete),
    );
    return actionList;
  }

  List<Widget> trashPrimary(Note note, BuildContext context) {
    final actionList = <Widget>[];
    actionList.add(
      Utilities.restoreAction(context, note),
    );
    return actionList;
  }

  slidableActions getPrimary(ScreenTypes topScreen) {
    switch (topScreen) {
      case ScreenTypes.Hidden:
        return hiddenPrimary;

      case ScreenTypes.Archive:
        return archivePrimary;

      case ScreenTypes.Trash:
        return trashPrimary;

      default:
        return homePrimary;
    }
  }

  slidableActions getSecondary(ScreenTypes topScreen) {
    switch (topScreen) {
      case ScreenTypes.Hidden:
        return hiddenSecondary;

      case ScreenTypes.Archive:
        return archiveSecondary;

      case ScreenTypes.Trash:
        return trashSecondary;

      default:
        return homeSecondary;
    }
  }
}
