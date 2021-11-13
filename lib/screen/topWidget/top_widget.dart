import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

typedef SlidableActions = Function(Note note, BuildContext context);
typedef ActionGen = Widget Function(Note note, BuildContext context);
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
      case ScreenTypes.hidden:
        return MyAppBar(
          title: Text(Language.of(context).hidden),
        );
      case ScreenTypes.home:
        return MyAppBar(
          title: Text(Language.of(context).home),
        );

      case ScreenTypes.archive:
        return MyAppBar(
          title: Text(Language.of(context).archive),
        );

      case ScreenTypes.backup:
        return MyAppBar(
          title: Text(Language.of(context).backup),
        );

      case ScreenTypes.trash:
        return MyAppBar(
          title: Text(Language.of(context).trash),
        );

      case ScreenTypes.aboutMe:
        return MyAppBar(
          title: Text(Language.of(context).about),
          // TODO add attribution
        );

      case ScreenTypes.settings:
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
      case ScreenTypes.hidden:
        return Fab(
          onFabTap,
          noteState: NoteState.hidden,
        );
      case ScreenTypes.archive:
        return Fab(
          onFabTap,
          noteState: NoteState.archived,
        );
      case ScreenTypes.trash:
        return Fab(
          onTrashFabTap,
          icon: const Icon(Icons.delete_forever_outlined),
        );
      case ScreenTypes.home:
        return Fab(onFabTap);
      default:
        return null;
    }
  }

  Future<void> onFabTap(BuildContext context, NoteState noteState) async {
    final emptyNote = Note(
      id: const Uuid().v4(),
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
      case ScreenTypes.backup:
        return const BackUpScreenHelper();

      case ScreenTypes.aboutMe:
        return const AboutMe();

      case ScreenTypes.settings:
        return const SettingsScreen();
      // return const SettingsScreenHelper();

      case ScreenTypes.lock:
        return const ErrorScreen();

      case ScreenTypes.setpass:
        return const ErrorScreen();

      case ScreenTypes.home:
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
      case ScreenTypes.hidden:
        return NoteState.hidden;

      case ScreenTypes.archive:
        return NoteState.archived;

      case ScreenTypes.trash:
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
      case ScreenTypes.hidden:
        return hiddenPrimary;

      case ScreenTypes.archive:
        return archivePrimary;

      case ScreenTypes.trash:
        return trashPrimary;

      default:
        return homePrimary;
    }
  }

  SlidableActions getSecondary(ScreenTypes topScreen) {
    switch (topScreen) {
      case ScreenTypes.hidden:
        return hiddenSecondary;

      case ScreenTypes.archive:
        return archiveSecondary;

      case ScreenTypes.trash:
        return trashSecondary;

      default:
        return homeSecondary;
    }
  }
}
