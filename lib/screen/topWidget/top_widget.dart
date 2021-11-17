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
  Widget myDrawer(BuildContext context) {
    return const MyDrawer();
  }

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
          // TODO add attribution and contribution
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

  ActionPane homePrimary(Note note, BuildContext context) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        Utilities.hideAction(context, note),
        Utilities.archiveAction(context, note),
      ],
    );
  }

  ActionPane homeSecondary(Note note, BuildContext context) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        Utilities.copyAction(context, note),
        Utilities.trashAction(context, note)
      ],
    );
  }

  ActionPane hiddenPrimary(Note note, BuildContext context) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        Utilities.unHideAction(context, note),
      ],
    );
  }

  ActionPane hiddenSecondary(Note note, BuildContext context) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        Utilities.trashAction(context, note),
      ],
    );
  }

  ActionPane archivePrimary(Note note, BuildContext context) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        Utilities.hideAction(context, note),
        Utilities.unArchiveAction(context, note),
      ],
    );
  }

  ActionPane archiveSecondary(Note note, BuildContext context) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        Utilities.copyAction(context, note),
        Utilities.trashAction(context, note),
      ],
    );
  }

  ActionPane trashSecondary(Note note, BuildContext context) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        Utilities.deleteAction(context, note,
            shouldAsk: Provider.of<LockChecker>(context, listen: false)
                .directlyDelete),
      ],
    );
  }

  ActionPane trashPrimary(Note note, BuildContext context) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        Utilities.restoreAction(context, note),
      ],
    );
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
