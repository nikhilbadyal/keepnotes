//25-11-2021 04:06 PM

import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

Widget getBody(final ScreenTypes topScreen, final BuildContext context) {
  switch (topScreen) {
    case ScreenTypes.aboutMe:
      return const AboutMe();
    case ScreenTypes.settings:
      return const SettingsScreen();
    case ScreenTypes.login:
      return const Login();
    case ScreenTypes.forgotPassword:
      return const ForgetPassword();
    case ScreenTypes.signup:
      return const SignUp();
    case ScreenTypes.enterPin:
      return const LockScreen();
    case ScreenTypes.setpass:
      return const SetPassword();
    default:
      final notesType = topScreen.getNoteSate;
      final primary = getPrimary(topScreen);
      final secondary = getSecondary(topScreen);
      return Body(
        fromWhere: notesType,
        primary: primary,
        secondary: secondary,
      );
  }
}

SlidableActions getPrimary(final ScreenTypes topScreen) {
  switch (topScreen) {
    case ScreenTypes.hidden:
      return hiddenLeft;
    case ScreenTypes.archive:
      return archiveLeft;
    case ScreenTypes.trash:
      return trashLeft;
    default:
      return homeLeft;
  }
}

SlidableActions getSecondary(final ScreenTypes topScreen) {
  switch (topScreen) {
    case ScreenTypes.hidden:
      return hiddenRight;
    case ScreenTypes.archive:
      return archiveRight;
    case ScreenTypes.trash:
      return trashRight;
    default:
      return homeRight;
  }
}

ActionPane homeLeft(final Note note, final BuildContext context) {
  return ActionPane(
    motion: const StretchMotion(),
    children: [
      slidableAction(
          context.language.hide,
          context.theme.textTheme.bodyText1!.color ?? Colors.redAccent,
          note,
          TablerIcons.ghost, (final context) async {
        final status = context.appConfig.password.isNotEmpty;
        if (!status) {
          await showDialog(
            barrierDismissible: true,
            context: context,
            builder: (final context) => MyAlertDialog(
              content: Text(context.language.setPasswordFirst),
            ),
          );
        } else {
          await Provider.of<NotesHelper>(context, listen: false).hide(note);
        }
      }),
      slidableAction(
        context.language.archive,
        context.theme.textTheme.bodyText1!.color ?? Colors.redAccent,
        note,
        Icons.archive_outlined,
        (final context) => unawaited(
          Provider.of<NotesHelper>(context, listen: false).archive(note),
        ),
      ),
    ],
  );
}

ActionPane homeRight(final Note note, final BuildContext context) {
  return ActionPane(
    motion: const StretchMotion(),
    children: [
      slidableAction(
        context.language.copy,
        context.theme.textTheme.bodyText1!.color ?? Colors.redAccent,
        note,
        Icons.copy_outlined,
        (final context) => unawaited(
          Provider.of<NotesHelper>(context, listen: false).copy(note),
        ),
      ),
      slidableAction(
        context.language.trash,
        context.theme.textTheme.bodyText1!.color ?? Colors.redAccent,
        note,
        Icons.delete_outlined,
        (final context) => unawaited(
          Provider.of<NotesHelper>(context, listen: false).trash(note),
        ),
      )
    ],
  );
}

ActionPane? hiddenLeft(final Note note, final BuildContext context) {
  return ActionPane(
    motion: const StretchMotion(),
    children: [
      slidableAction(
        context.language.unhide,
        context.theme.textTheme.bodyText1!.color ?? Colors.redAccent,
        note,
        Icons.remove_red_eye_outlined,
        (final context) => unawaited(
          Provider.of<NotesHelper>(context, listen: false).unhide(note),
        ),
      )
    ],
  );
}

ActionPane hiddenRight(final Note note, final BuildContext context) {
  return ActionPane(
    motion: const StretchMotion(),
    children: [
      slidableAction(
        context.language.trash,
        context.theme.textTheme.bodyText1!.color ?? Colors.redAccent,
        note,
        Icons.delete_outlined,
        (final context) => unawaited(
          Provider.of<NotesHelper>(context, listen: false).trash(note),
        ),
      )
    ],
  );
}

ActionPane? archiveLeft(final Note note, final BuildContext context) {
  return ActionPane(
    motion: const StretchMotion(),
    children: [
      slidableAction(
          context.language.hide,
          context.theme.textTheme.bodyText1!.color ?? Colors.redAccent,
          note,
          TablerIcons.ghost, (final context) async {
        final status = context.appConfig.password.isNotEmpty;
        if (!status) {
          await showDialog(
            barrierDismissible: true,
            context: context,
            builder: (final context) => MyAlertDialog(
              content: Text(context.language.setPasswordFirst),
            ),
          );
        } else {
          await Provider.of<NotesHelper>(context, listen: false).hide(note);
        }
      }),
      slidableAction(
        context.language.unarchive,
        context.theme.textTheme.bodyText1!.color ?? Colors.redAccent,
        note,
        Icons.unarchive_outlined,
        (final context) => unawaited(
          Provider.of<NotesHelper>(context, listen: false).unarchive(note),
        ),
      ),
    ],
  );
}

ActionPane archiveRight(final Note note, final BuildContext context) {
  return ActionPane(
    motion: const StretchMotion(),
    children: [
      slidableAction(
        context.language.copy,
        context.theme.textTheme.bodyText1!.color ?? Colors.redAccent,
        note,
        Icons.copy_outlined,
        (final context) => unawaited(
          Provider.of<NotesHelper>(context, listen: false).copy(note),
        ),
      ),
      slidableAction(
        context.language.trash,
        context.theme.textTheme.bodyText1!.color ?? Colors.redAccent,
        note,
        Icons.delete_outlined,
        (final context) => unawaited(
          Provider.of<NotesHelper>(context, listen: false).trash(note),
        ),
      ),
    ],
  );
}

ActionPane trashRight(final Note note, final BuildContext context) {
  return ActionPane(
    motion: const StretchMotion(),
    children: [
      slidableAction(
          context.language.delete,
          context.theme.textTheme.bodyText1!.color ?? Colors.redAccent,
          note,
          Icons.delete_forever_outlined, (final context) async {
        await showDialog<bool>(
          barrierDismissible: false,
          context: context,
          builder: (final context) => MyAlertDialog(
            content: Text(context.language.deleteNotePermanently),
            actions: [
              TextButton(
                onPressed: () {
                  Provider.of<NotesHelper>(context, listen: false).delete(note);
                  context.previousPage();
                },
                child: Text(context.language.alertDialogOp1),
              ),
              TextButton(
                onPressed: context.previousPage,
                child: Text(context.language.alertDialogOp2),
              )
            ],
          ),
        );
      }),
    ],
  );
}

ActionPane trashLeft(final Note note, final BuildContext context) {
  return ActionPane(
    motion: const StretchMotion(),
    children: [
      slidableAction(
        context.language.restore,
        context.theme.textTheme.bodyText1!.color ?? Colors.redAccent,
        note,
        Icons.restore_outlined,
        (final context) => unawaited(
          Provider.of<NotesHelper>(context, listen: false).undelete(note),
        ),
      ),
    ],
  );
}
