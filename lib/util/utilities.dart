// ignore_for_file: use_build_context_synchronously

import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class Utilities {
  static late SharedPreferences prefs;
}

Future<void> onModalHideTap(final BuildContext context, final Note note,
    final Timer autoSaver, final Function() saveNote) async {
  final status =
      Provider.of<AppConfiguration>(context, listen: false).password.isNotEmpty;
  if (!status) {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (final context) => MyAlertDialog(
        content: Text(Language.of(context).setPasswordFirst),
      ),
    );
  } else {
    autoSaver.cancel();
    saveNote();
    final wantedRoute = getRoute(note.state);
    await onHideTap(context, note);
    Navigator.of(context).popUntil(
      (final route) => route.settings.name == wantedRoute,
    );
  }
}

Future<void> onModalArchiveTap(final BuildContext context, final Note note,
    final Timer autoSaver, final Function() saveNote) async {
  autoSaver.cancel();
  saveNote();
  final wantedRoute = getRoute(note.state);
  onArchiveTap(context, note);
  Navigator.of(context).popUntil(ModalRoute.withName(wantedRoute));
}

Future<void> onModalUnArchiveTap(final BuildContext context, final Note note,
    final Timer autoSaver, final Function() saveNote) async {
  autoSaver.cancel();
  saveNote();
  final wantedRoute = getRoute(note.state);
  onUnArchiveTap(context, note);
  Navigator.of(context).popUntil(
    (final route) => route.settings.name == wantedRoute,
  );
}

Future<void> onModalTrashTap(final BuildContext context, final Note note,
    final Timer autoSaver, final Function() saveNote) async {
  autoSaver.cancel();
  saveNote();
  final wantedRoute = getRoute(note.state);
  onTrashTap(context, note);
  Navigator.of(context).popUntil(
    (final route) => route.settings.name == wantedRoute,
  );
}

void onModalCopyToClipboardTap(final BuildContext context, final Note note,
    final Timer autoSaver, final Function() saveNote) {
  autoSaver.cancel();
  saveNote();
  Navigator.of(context).pop();
  unawaited(Clipboard.setData(
    ClipboardData(text: note.title),
  ).then((final _) {
    Clipboard.setData(
      ClipboardData(text: note.content),
    ).then(
      (final value) => showSnackbar(context, Language.of(context).done,
          snackBarBehavior: SnackBarBehavior.floating),
    );
  }));
}

Future<void> resetPassword(final BuildContext context) async {
  await Provider.of<NotesHelper>(context, listen: false).deleteAllHidden();
  showSnackbar(
    context,
    Language.of(context).passwordReset,
  );
  await Provider.of<AppConfiguration>(context, listen: false).resetConfig();
  await navigate('', context, AppRoutes.homeScreen);
}

Future<bool> launchUrl(final BuildContext context, final String url) async {
  if (await canLaunch(url)) {
    return launch(url);
  } else {
    getSnackBar(context, Language.of(context).unableToLaunchEmail);
    return false;
  }
}

final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'nikhildevelops@gmail.com',
    queryParameters: {'subject': 'Suggestion for the app'});

SnackBarAction resetAction(final BuildContext context) => SnackBarAction(
      label: Language.of(context).reset,
      onPressed: () async {
        final status = await showDialog<bool>(
              barrierDismissible: false,
              context: context,
              builder: (final context) => Center(
                child: SingleChildScrollView(
                  child: MyAlertDialog(
                    content:
                        Text(Language.of(context).deleteAllNotesResetPassword),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(Language.of(context).alertDialogOp1),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop(false);
                        },
                        child: Text(Language.of(context).alertDialogOp2),
                      ),
                    ],
                  ),
                ),
              ),
            ) ??
            false;
        if (status) {
          await resetPassword(context);
        }
      },
    );

void showSnackbar(final BuildContext context, final String data,
    {final Duration duration = const Duration(seconds: 2),
    final SnackBarBehavior? snackBarBehavior}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    getSnackBar(context, data,
        duration: duration, snackBarBehavior: snackBarBehavior),
  );
}

SnackBar getSnackBar(final BuildContext context, final String data,
        {final Duration duration = const Duration(seconds: 1),
        final SnackBarAction? action,
        final SnackBarBehavior? snackBarBehavior}) =>
    SnackBar(
      key: UniqueKey(),
      content: Text(
        data,
      ),
      action: action,
      duration: duration,
      behavior: snackBarBehavior,
    );

Widget hideAction(final BuildContext context, final Note note) {
  return SlidableAction(
    autoClose: false,
    icon: TablerIcons.ghost,
    label: Language.of(context).hide,
    backgroundColor: Colors.transparent,
    foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
    onPressed: (final context) => onHideTap(context, note),
  );
}

void handleError(final BuildContext context) {
  showSnackbar(
    context,
    Language.of(context).error,
  );
}

Future<void> onHideTap(final BuildContext context, final Note note) async {
  final status =
      Provider.of<AppConfiguration>(context, listen: false).password.isNotEmpty;
  if (!status) {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (final context) => MyAlertDialog(
        content: Text(Language.of(context).setPasswordFirst),
      ),
    );
  } else {
    final value =
        await Provider.of<NotesHelper>(context, listen: false).hide(note);
    if (!value) {
      handleError(context);
    }
  }
}

Widget deleteAction(final BuildContext context, final Note note,
        {final bool shouldAsk = true}) =>
    SlidableAction(
      autoClose: false,
      icon: Icons.delete_forever_outlined,
      label: Language.of(context).delete,
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
      onPressed: (final context) =>
          onDeleteTap(context, note, deleteDirectly: shouldAsk),
    );

Future<void> onDeleteTap(final BuildContext context, final Note note,
    {final bool deleteDirectly = true}) async {
  var choice = true;
  if (!deleteDirectly) {
    choice = await showDialog<bool>(
          barrierDismissible: false,
          context: context,
      builder: (final context) => MyAlertDialog(
            content: Text(Language.of(context).deleteNotePermanently),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(Language.of(context).alertDialogOp1),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(Language.of(context).alertDialogOp2),
              )
            ],
          ),
        ) ??
        false;
  }
  if (choice) {
    unawaited(Provider.of<NotesHelper>(context, listen: false)
        .delete(note)
        .then((final value) {
      if (!value) {
        handleError(context);
      }
    }));
  }
}

Widget trashAction(final BuildContext context, final Note note) {
  return SlidableAction(
    autoClose: false,
    icon: Icons.delete_outline,
    label: Language.of(context).delete,
    backgroundColor: Colors.transparent,
    foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
    onPressed: (final context) => onTrashTap(context, note),
  );
}

void onTrashTap(final BuildContext context, final Note note) {
  unawaited(Provider.of<NotesHelper>(context, listen: false)
      .trash(note)
      .then((final value) {
    if (!value) {
      handleError(context);
    }
  }));
}

Widget copyAction(final BuildContext context, final Note note) =>
    SlidableAction(
      autoClose: false,
      icon: TablerIcons.copy,
      label: Language.of(context).copy,
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
      onPressed: (final context) => onCopyTap(context, note),
    );

void onCopyTap(final BuildContext context, final Note note) {
  unawaited(Provider.of<NotesHelper>(context, listen: false)
      .copy(note)
      .then((final value) {
    if (!value) {
      handleError(context);
    }
  }));
}

Widget archiveAction(final BuildContext context, final Note note) =>
    SlidableAction(
      autoClose: false,
      icon: Icons.archive_outlined,
      label: Language.of(context).archive,
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
      onPressed: (final context) => onArchiveTap(context, note),
    );

void onArchiveTap(final BuildContext context, final Note note) {
  unawaited(Provider.of<NotesHelper>(context, listen: false)
      .archive(note)
      .then((final value) {
    if (!value) {
      handleError(context);
    }
  }));
}

Widget unHideAction(final BuildContext context, final Note note) =>
    SlidableAction(
      autoClose: false,
      icon: Icons.drive_file_move_outline,
      label: Language.of(context).unhide,
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
      onPressed: (final context) => onUnHideTap(context, note),
    );

void onUnHideTap(final BuildContext context, final Note note) {
  unawaited(Provider.of<NotesHelper>(context, listen: false)
      .unhide(note)
      .then((final value) {
    if (!value) {
      handleError(context);
    }
  }));
}

Widget unArchiveAction(final BuildContext context, final Note note) =>
    SlidableAction(
      autoClose: false,
      icon: Icons.unarchive_outlined,
      label: Language.of(context).unarchive,
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
      onPressed: (final context) => onUnArchiveTap(context, note),
    );

void onUnArchiveTap(final BuildContext context, final Note note) {
  unawaited(Provider.of<NotesHelper>(context, listen: false)
      .unarchive(note)
      .then((final value) {
    if (!value) {
      handleError(context);
    }
  }));
}

Widget restoreAction(final BuildContext context, final Note note) =>
    SlidableAction(
      autoClose: false,
      icon: Icons.restore_from_trash_outlined,
      label: Language.of(context).restore,
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
      onPressed: (final context) => onRestoreTap(context, note),
    );

void onRestoreTap(final BuildContext context, final Note note) {
  unawaited(Provider.of<NotesHelper>(context, listen: false)
      .undelete(note)
      .then((final value) {
    if (!value) {
      handleError(context);
    }
  }));
}

void onDeleteAllTap(final BuildContext context) {
  Provider.of<NotesHelper>(context, listen: false).emptyTrash();
}

void initialize(final BuildContext context) {
  final curUser = Provider.of<Auth>(context, listen: false).auth.currentUser;
  encryption = Encrypt(curUser!.uid);
  Provider.of<AppConfiguration>(context, listen: false).password =
      encryption.decryptStr(getStringFromSF('password') ?? '');
  FirebaseDatabaseHelper(curUser.uid);
}

Future<bool> requestPermission(final Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    final result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
  }
  return false;
}
