import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class Utilities {
  static late SharedPreferences prefs;
  static const appName = 'KeepNotes';

  static Future<void> onModalHideTap(final BuildContext context,
      final Note note, final Timer autoSaver, final Function() saveNote) async {
    final status =
        Provider.of<LockChecker>(context, listen: false).password.isNotEmpty;
    if (!status) {
      await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (final _) => MyAlertDialog(
          content: Text(Language.of(context).setPasswordFirst),
        ),
      );
    } else {
      autoSaver.cancel();
      saveNote();
      final wantedRoute = getRoute(note.state);
      await Utilities.onHideTap(context, note);
      Navigator.of(context).popUntil(
        (final route) => route.settings.name == wantedRoute,
      );
    }
  }

  static Future<void> onModalArchiveTap(final BuildContext context,
      final Note note, final Timer autoSaver, final Function() saveNote) async {
    autoSaver.cancel();
    saveNote();
    final wantedRoute = getRoute(note.state);
    Utilities.onArchiveTap(context, note);
    Navigator.of(context).popUntil(ModalRoute.withName(wantedRoute));
  }

  static Future<void> onModalUnArchiveTap(final BuildContext context,
      final Note note, final Timer autoSaver, final Function() saveNote) async {
    autoSaver.cancel();
    saveNote();
    final wantedRoute = getRoute(note.state);
    Utilities.onUnArchiveTap(context, note);
    Navigator.of(context).popUntil(
      (final route) => route.settings.name == wantedRoute,
    );
  }

  static Future<void> onModalTrashTap(final BuildContext context,
      final Note note, final Timer autoSaver, final Function() saveNote) async {
    autoSaver.cancel();
    saveNote();
    final wantedRoute = getRoute(note.state);
    Utilities.onTrashTap(context, note);
    Navigator.of(context).popUntil(
      (final route) => route.settings.name == wantedRoute,
    );
  }

  static void onModalCopyToClipboardTap(final BuildContext context,
      final Note note, final Timer autoSaver, final Function() saveNote) {
    autoSaver.cancel();
    saveNote();
    Navigator.of(context).pop();
    unawaited(Clipboard.setData(
      ClipboardData(text: note.title),
    ).then((final _) {
      Clipboard.setData(
        ClipboardData(text: note.content),
      ).then(
        (final value) => Utilities.showSnackbar(
            context, Language.of(context).done,
            snackBarBehavior: SnackBarBehavior.floating),
      );
    }));
  }

  static Future<void> resetPassword(final BuildContext context,
      {final bool deleteAllNotes = false}) async {
    if (deleteAllNotes) {
      await Provider.of<NotesHelper>(context, listen: false).deleteAllHidden();
    } else {
      Utilities.showSnackbar(context, Language.of(context).done);
      unawaited(Provider.of<NotesHelper>(context, listen: false)
          .recryptEverything(
              Provider.of<LockChecker>(context, listen: false).password)
          .then((final value) {
        if (value) {
          Utilities.showSnackbar(
              context, Language.of(context).setPassAndHideAgain);
        }
      }));
    }
    Utilities.showSnackbar(
      context,
      Language.of(context).passwordReset,
    );
    await Provider.of<LockChecker>(context, listen: false)
        .resetConfig(shouldResetBio: true);
    await navigate('', context, AppRoutes.homeScreen);
  }

  static Future<bool> launchUrl(
      final BuildContext context, final String url) async {
    if (await canLaunch(url)) {
      return launch(url);
    } else {
      getSnackBar(context, Language.of(context).unableToLaunchEmail);
      return false;
    }
  }

  static final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'nikhildevelops@gmail.com',
      queryParameters: {'subject': 'Suggestion for the app'});

  static String navChecker(final NoteState state) {
    if (state == NoteState.archived) {
      return AppRoutes.archiveScreen;
    } else if (state == NoteState.hidden) {
      return AppRoutes.hiddenScreen;
    } else if (state == NoteState.deleted) {
      return AppRoutes.trashScreen;
    } else {
      return AppRoutes.homeScreen;
    }
  }

  static SnackBarAction resetAction(final BuildContext context) =>
      SnackBarAction(
        label: Language.of(context).reset,
        onPressed: () async {
          final status = await showDialog<bool>(
                barrierDismissible: false,
                context: context,
                builder: (final context) => Center(
                  child: SingleChildScrollView(
                    child: MyAlertDialog(
                      content: Text(
                          Language.of(context).deleteAllNotesResetPassword),
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
            await resetPassword(context, deleteAllNotes: true);
          }
        },
      );

  static void showSnackbar(final BuildContext context, final String data,
      {final Duration duration = const Duration(seconds: 1),
      final SnackBarBehavior? snackBarBehavior}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      getSnackBar(context, data, snackBarBehavior: snackBarBehavior),
    );
  }

  static SnackBar getSnackBar(final BuildContext context, final String data,
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
        behavior: snackBarBehavior ?? Theme.of(context).snackBarTheme.behavior,
      );

  static Widget hideAction(final BuildContext context, final Note note) {
    return SlidableAction(
      autoClose: false,
      icon: TablerIcons.ghost,
      label: Language.of(context).hide,
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
      onPressed: (final _) => onHideTap(context, note),
    );
  }

  static void handleError(final BuildContext context) {
    Utilities.showSnackbar(
      context,
      Language.of(context).error,
    );
  }

  static Future<void> onHideTap(
      final BuildContext context, final Note note) async {
    final status =
        Provider.of<LockChecker>(context, listen: false).password.isNotEmpty;
    if (!status) {
      await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (final _) => MyAlertDialog(
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

  static Widget deleteAction(final BuildContext context, final Note note,
          {final bool shouldAsk = true}) =>
      SlidableAction(
        autoClose: false,
        icon: Icons.delete_forever_outlined,
        label: Language.of(context).delete,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
        onPressed: (final _) =>
            onDeleteTap(context, note, deleteDirectly: shouldAsk),
      );

  static Future<void> onDeleteTap(final BuildContext context, final Note note,
      {final bool deleteDirectly = true}) async {
    var choice = true;
    if (!deleteDirectly) {
      choice = await showDialog<bool>(
            barrierDismissible: false,
            context: context,
            builder: (final _) => MyAlertDialog(
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

  static Widget trashAction(final BuildContext context, final Note note) {
    return SlidableAction(
      autoClose: false,
      icon: Icons.delete_outline,
      label: Language.of(context).delete,
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
      onPressed: (final _) => onTrashTap(context, note),
    );
  }

  static void onTrashTap(final BuildContext context, final Note note) {
    unawaited(Provider.of<NotesHelper>(context, listen: false)
        .trash(note)
        .then((final value) {
      if (!value) {
        handleError(context);
      }
    }));
  }

  static Widget copyAction(final BuildContext context, final Note note) =>
      SlidableAction(
        autoClose: false,
        icon: TablerIcons.copy,
        label: Language.of(context).copy,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
        onPressed: (final _) => onCopyTap(context, note),
      );

  static void onCopyTap(final BuildContext context, final Note note) {
    unawaited(Provider.of<NotesHelper>(context, listen: false)
        .copy(note)
        .then((final value) {
      if (!value) {
        handleError(context);
      }
    }));
  }

  static Widget archiveAction(final BuildContext context, final Note note) =>
      SlidableAction(
        autoClose: false,
        icon: Icons.archive_outlined,
        label: Language.of(context).archive,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
        onPressed: (final _) => onArchiveTap(context, note),
      );

  static void onArchiveTap(final BuildContext context, final Note note) {
    unawaited(Provider.of<NotesHelper>(context, listen: false)
        .archive(note)
        .then((final value) {
      if (!value) {
        handleError(context);
      }
    }));
  }

  static Widget unHideAction(final BuildContext context, final Note note) =>
      SlidableAction(
        autoClose: false,
        icon: Icons.drive_file_move_outline,
        label: Language.of(context).unhide,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
        onPressed: (final _) => onUnHideTap(context, note),
      );

  static void onUnHideTap(final BuildContext context, final Note note) {
    unawaited(Provider.of<NotesHelper>(context, listen: false)
        .unhide(note)
        .then((final value) {
      if (!value) {
        handleError(context);
      }
    }));
  }

  static Widget unArchiveAction(final BuildContext context, final Note note) =>
      SlidableAction(
        autoClose: false,
        icon: Icons.unarchive_outlined,
        label: Language.of(context).unarchive,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
        onPressed: (final _) => onUnArchiveTap(context, note),
      );

  static void onUnArchiveTap(final BuildContext context, final Note note) {
    unawaited(Provider.of<NotesHelper>(context, listen: false)
        .unarchive(note)
        .then((final value) {
      if (!value) {
        handleError(context);
      }
    }));
  }

  static Widget restoreAction(final BuildContext context, final Note note) =>
      SlidableAction(
        autoClose: false,
        icon: Icons.restore_from_trash_outlined,
        label: Language.of(context).restore,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
        onPressed: (final _) => onRestoreTap(context, note),
      );

  static void onRestoreTap(final BuildContext context, final Note note) {
    unawaited(Provider.of<NotesHelper>(context, listen: false)
        .undelete(note)
        .then((final value) {
      if (!value) {
        handleError(context);
      }
    }));
  }

  static void onDeleteAllTap(final BuildContext context) {
    Provider.of<NotesHelper>(context, listen: false).emptyTrash();
  }

  static void initialize(final BuildContext context) {
    final curUser = Provider.of<Auth>(context, listen: false).auth.currentUser;
    encryption = Encrypt(curUser!.uid);
    Provider.of<LockChecker>(context, listen: false).password =
        encryption.decryptStr(getStringFromSF('password') ?? '');
    FirebaseDatabaseHelper(curUser.uid);
  }
}
