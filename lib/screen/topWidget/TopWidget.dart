import 'package:flutter/material.dart';
import 'package:notes/model/Languages.dart';
import 'package:notes/model/Note.dart';
import 'package:notes/screen/about/AboutMeScreen.dart';
import 'package:notes/screen/backup/BackupRestore.dart';
import 'package:notes/screen/home/HomeBody.dart';
import 'package:notes/screen/settings/SettingsScreen.dart';
import 'package:notes/screen/settings/NewSettingsScreen.dart';
import 'package:notes/screen/topWidget/AppBar.dart';
import 'package:notes/screen/topWidget/Body.dart';
import 'package:notes/screen/topWidget/BottomSheet.dart';
import 'package:notes/screen/topWidget/FloatingActionButton.dart';
import 'package:notes/screen/topWidget/MyDrawer.dart';
import 'package:notes/screen/topWidget/TopWidgetBase.dart';
import 'package:notes/util/ErrorScreen.dart';
import 'package:notes/util/LockManager.dart';
import 'package:notes/util/Navigations.dart';
import 'package:notes/util/Utilities.dart';
import 'package:provider/provider.dart';

typedef SlidableActions = Function(Note note, BuildContext context);
typedef ActionGen = Widget Function(Note note, BuildContext context);
typedef BackPresAction = Future<bool> Function();

class ScreenContainer extends TopWidgetBase {
  const ScreenContainer({
    required this.topScreen,
    Key? key,
  }) : super(key: key);
  final ScreenTypes topScreen;

  @override
  Widget myDrawer(BuildContext context) => const MyDrawer();

  @override
  MyAppBar? appBar(BuildContext context) {
    switch (topScreen) {
      case ScreenTypes.Hidden:
        return MyAppBar(
          title: Text(Language.of(context).hidden),
        );
      case ScreenTypes.Home:
        return MyAppBar(
          title: Text(Language.of(context).home),
        );

      case ScreenTypes.Archive:
        return MyAppBar(
          title: Text(Language.of(context).archive),
        );

      case ScreenTypes.Backup:
        return MyAppBar(
          title: Text(Language.of(context).backup),
        );

      case ScreenTypes.Trash:
        return MyAppBar(
          title: Text(Language.of(context).trash),
        );

      case ScreenTypes.AboutMe:
        return MyAppBar(
          title: Text(Language.of(context).about),
          // TODO add attribution
        );

      case ScreenTypes.Settings:
        return MyAppBar(
          title: Text(Language.of(context).settings),
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
          noteState: NoteState.archived,
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
        return const SettingsScreen();
      // return const SettingsScreenHelper();

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
    final actionList = <Widget>[
      Utilities.hideAction(context, note),
      Utilities.archiveAction(context, note),
    ];
    return actionList;
  }

  List<Widget> homeSecondary(Note note, BuildContext context) {
    final actionList = <Widget>[
      Utilities.copyAction(context, note),
      Utilities.trashAction(context, note)
    ];

    return actionList;
  }

  List<Widget> hiddenPrimary(Note note, BuildContext context) {
    final actionList = <Widget>[
      Utilities.unHideAction(context, note),
    ];
    return actionList;
  }

  List<Widget> hiddenSecondary(Note note, BuildContext context) {
    final actionList = <Widget>[
      Utilities.trashAction(context, note),
    ];
    return actionList;
  }

  List<Widget> archivePrimary(Note note, BuildContext context) {
    final actionList = <Widget>[
      Utilities.hideAction(context, note),
      Utilities.unArchiveAction(context, note),
    ];
    return actionList;
  }

  List<Widget> archiveSecondary(Note note, BuildContext context) {
    final actionList = <Widget>[
      Utilities.copyAction(context, note),
      Utilities.trashAction(context, note),
    ];
    return actionList;
  }

  List<Widget> trashSecondary(Note note, BuildContext context) {
    final actionList = <Widget>[
      Utilities.deleteAction(context, note,
          shouldAsk:
              Provider.of<LockChecker>(context, listen: false).directlyDelete),
    ];

    return actionList;
  }

  List<Widget> trashPrimary(Note note, BuildContext context) {
    final actionList = <Widget>[
      Utilities.restoreAction(context, note),
    ];
    return actionList;
  }

  SlidableActions getPrimary(ScreenTypes topScreen) {
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

  SlidableActions getSecondary(ScreenTypes topScreen) {
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
