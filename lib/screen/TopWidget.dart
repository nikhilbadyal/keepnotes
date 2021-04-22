import 'package:flutter/material.dart';
import 'package:notes/main.dart';
import 'package:notes/model/Note.dart';
import 'package:notes/screen/AboutMeScreen.dart';
import 'package:notes/screen/BackupRestore.dart';
import 'package:notes/screen/SettingsScreen.dart';
import 'package:notes/screen/TopWidgetBase.dart';
import 'package:notes/util/ErrorScreen.dart';
import 'package:notes/util/Languages/Languages.dart';
import 'package:notes/util/Navigations.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/widget/AppBar.dart';
import 'package:notes/widget/Body.dart';
import 'package:notes/widget/BottomSheet.dart';
import 'package:notes/widget/FloatingActionButton.dart';
import 'package:notes/widget/HomeBody.dart';
import 'package:notes/widget/MyDrawer.dart';

typedef slidableActions = Function(Note note, BuildContext context);
typedef actionGen = Widget Function(Note note, BuildContext context);
typedef BackPresAction = Future<bool> Function();

class ScreenContainer extends TopWidgetBase {
  const ScreenContainer({Key? key, required this.topScreen}) : super(key: key);
  final ScreenTypes topScreen;

  @override
  Widget myDrawer(BuildContext context) {
    return MyDrawer();
  }

  @override
  MyAppBar? appBar(BuildContext context) {
    switch (topScreen) {
      case ScreenTypes.Hidden:
        return MyAppBar(
          title: Text(Languages.of(context).hidden),
        );
      case ScreenTypes.Home:
        return MyAppBar(
          title: Text(Languages.of(context).home),
        );

      case ScreenTypes.Archive:
        return MyAppBar(
          title: Text(Languages.of(context).archive),
        );

      case ScreenTypes.Backup:
        return MyAppBar(
          title: Text(Languages.of(context).backup),
        );

      case ScreenTypes.Trash:
        return MyAppBar(
          title: Text(Languages.of(context).trash),
        );

      case ScreenTypes.AboutMe:
        return MyAppBar(
          title: Text(Languages.of(context).about),
          // TODO add attribution
        );

      case ScreenTypes.Settings:
        return MyAppBar(
          title: Text(Languages.of(context).settings),
        );
      default:
        return null;
    }
  }

  @override
  Widget? floatingActionButton(BuildContext context) {
    switch (topScreen) {
      case ScreenTypes.Hidden:
        return Fab(
          onFabTap,
          noteState: NoteState.hidden,
        );
      case ScreenTypes.Archive:
        return Fab(
          onFabTap,
          noteState: NoteState.hidden,
        );
      case ScreenTypes.Trash:
        return Fab(
          onTrashFabTap,
          icon: const Icon(Icons.delete_forever_outlined),
        );
      case ScreenTypes.Home:
        return Fab(onFabTap);
      default:
        return null;
    }
  }

  Future<void> onFabTap(BuildContext context, NoteState noteState) async {
    final emptyNote = Note(
      lastModify: DateTime.now(),
      state: noteState,
    );
    await goToNoteEditScreen(
        context: context, note: emptyNote, shouldAutoFocus: true);
  }

  Future<void> onTrashFabTap(BuildContext context, NoteState _) async {
    moreOptions(context);
  }

  @override
  Widget body(BuildContext context) {
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

    actionList.add(
      Utilities.deleteAction(context, note,
          shouldAsk: lockChecker.directlyDelete),
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
