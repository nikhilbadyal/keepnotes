//25-11-2021 04:06 PM

import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';
import 'package:notes/screen/sign_up/sign_up.dart';

Widget getBody(final ScreenTypes topScreen, final BuildContext context) {
  switch (topScreen) {
    case ScreenTypes.backup:
      return const BackUpScreen();

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
    case ScreenTypes.welcome:
      return const Welcome();
    case ScreenTypes.lock:
      return const LockScreen();
    case ScreenTypes.setpass:
      return const SetPassword();

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

SlidableActions getPrimary(final ScreenTypes topScreen) {
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

SlidableActions getSecondary(final ScreenTypes topScreen) {
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

NoteState getNotesType(final ScreenTypes topScreen) {
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

ActionPane homePrimary(final Note note, final BuildContext context) {
  return ActionPane(
    motion: const StretchMotion(),
    children: [
      hideAction(context, note),
      archiveAction(context, note),
    ],
  );
}

ActionPane homeSecondary(final Note note, final BuildContext context) {
  return ActionPane(
    motion: const StretchMotion(),
    children: [copyAction(context, note), trashAction(context, note)],
  );
}

ActionPane hiddenPrimary(final Note note, final BuildContext context) {
  return ActionPane(
    motion: const StretchMotion(),
    children: [
      unHideAction(context, note),
    ],
  );
}

ActionPane hiddenSecondary(final Note note, final BuildContext context) {
  return ActionPane(
    motion: const StretchMotion(),
    children: [
      trashAction(context, note),
    ],
  );
}

ActionPane archivePrimary(final Note note, final BuildContext context) {
  return ActionPane(
    motion: const StretchMotion(),
    children: [
      hideAction(context, note),
      unArchiveAction(context, note),
    ],
  );
}

ActionPane archiveSecondary(final Note note, final BuildContext context) {
  return ActionPane(
    motion: const StretchMotion(),
    children: [
      copyAction(context, note),
      trashAction(context, note),
    ],
  );
}

ActionPane trashSecondary(final Note note, final BuildContext context) {
  return ActionPane(
    motion: const StretchMotion(),
    children: [
      deleteAction(context, note,
          shouldAsk: getBoolFromSF('directlyDelete') ?? true),
    ],
  );
}

ActionPane trashPrimary(final Note note, final BuildContext context) {
  return ActionPane(
    motion: const StretchMotion(),
    children: [
      restoreAction(context, note),
    ],
  );
}
