import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:notes/main.dart';
import 'package:notes/model/Note.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/util/AppConfiguration.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/Languages/Languages.dart';
import 'package:notes/util/Navigations.dart';
import 'package:notes/widget/AlertDialog.dart';
import 'package:notes/widget/SimpleDialog.dart';
import 'package:pedantic/pedantic.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

enum IconColorStatus { NoColor, RandomColor, PickedColor, UiColor }

MaterialColor createMaterialColor(Color color) {
  final strengths = <double>[.05];
  final swatch = <int, Color>{};
  final r = color.red;
  final g = color.green;
  final b = color.blue;

  for (var i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (final strength in strengths) {
    final ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

Color getRandomColor() {
  var color = Color(Random().nextInt(0xffffffff));
  while (color == selectedPrimaryColor || color == selectedAccentColor) {
    color = Color(Random().nextInt(0xffffffff));
  }
  return color;
}

class Utilities {
  static late SharedPreferences prefs;
  static const passLength = 4;
  static const aboutMePic = 'me.png';

  static late FlutterSecureStorage storage;

  static Future<void> resetPassword(BuildContext context,
      {bool deleteAllNotes = false}) async {
    if (deleteAllNotes) {
      await Provider.of<NotesHelper>(context, listen: false)
          .deleteAllHiddenNotesHelper();
    } else {
      Utilities.showSnackbar(context, Languages.of(context).done);
      unawaited(Provider.of<NotesHelper>(context, listen: false)
          .recryptEverything(lockChecker.password)
          .then((value) {
        if (value) {
          Utilities.showSnackbar(
              context, Languages.of(context).setPassAndHideAgain);
        }
      }));
    }
    Utilities.showSnackbar(
      context,
      Languages.of(context).passwordReset,
    );
    await lockChecker.resetConfig();
    await navigate('', context, NotesRoutes.homeScreen);
  }

  static Future<bool> launchUrl(String url) async {
    if (await canLaunch(url)) {
      return launch(url);
    } else {
      return false;
    }
  }

  static final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'nikhildevelops@gmail.com',
      queryParameters: {'subject': 'Suggestion/Issues for/in the app'});

  static String navChecker(NoteState state) {
    if (state == NoteState.archived) {
      return NotesRoutes.archiveScreen;
    } else if (state == NoteState.hidden) {
      return NotesRoutes.hiddenScreen;
    } else if (state == NoteState.deleted) {
      return NotesRoutes.trashScreen;
    } else {
      return NotesRoutes.homeScreen;
    }
  }

  static Future<bool> requestPermission(Permission permission) async {
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

  static SnackBarAction resetAction(BuildContext context) {
    return SnackBarAction(
      label: Languages.of(context).reset,
      onPressed: () async {
        await showDialog<bool>(
          context: context,
          builder: (context) => Center(
            child: SingleChildScrollView(
              child: MyAlertDialog(
                title: Text(Languages.of(context).message),
                content:
                    Text(Languages.of(context).deleteAllNotesResetPassword),
                actions: [
                  TextButton(
                    onPressed: () =>
                        resetPassword(context, deleteAllNotes: true),
                    child: Text(Languages.of(context).alertDialogOp1),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(Languages.of(context).alertDialogOp2),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showSnackbar(BuildContext context, String data,
      {Duration duration = const Duration(seconds: 1),
      SnackBarBehavior? snackBarBehavior}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      Utilities.getSnackBar(context, data, snackBarBehavior: snackBarBehavior),
    );
  }

  static SnackBar getSnackBar(BuildContext context, String data,
      {Duration duration = const Duration(seconds: 1),
      SnackBarAction? action,
      SnackBarBehavior? snackBarBehavior}) {
    return SnackBar(
      key: UniqueKey(),
      content: Text(
        data,
      ),
      action: action,
      duration: duration,
      behavior: snackBarBehavior ?? Theme.of(context).snackBarTheme.behavior,
    );
  }

  static Widget hideAction(BuildContext context, Note note) {
    return IconSlideAction(
      icon: TablerIcons.ghost,
      caption: Languages.of(context).hide,
      color: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
      onTap: () => onHideTap(context, note),
    );
  }

  static Future<void> onHideTap(BuildContext context, Note note) async {
    final status = lockChecker.passwordSet;
    if (!status) {
      await showDialog(
        context: context,
        builder: (_) {
          return MySimpleDialog(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(Languages.of(context).setPasswordFirst),
            ),
          );
        },
      );
    } else {
      final value = await Provider.of<NotesHelper>(context, listen: false)
          .hideNoteHelper(note);
      if (value) {
        Utilities.showSnackbar(
          context,
          Languages.of(context).done,
        );
      } else {
        Utilities.showSnackbar(
          context,
          Languages.of(context).error,
        );
      }
    }
  }

  static Widget deleteAction(BuildContext context, Note note,
      {bool shouldAsk = true}) {
    return IconSlideAction(
      icon: Icons.delete_forever_outlined,
      caption: Languages.of(context).delete,
      color: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
      //light

      onTap: () => onDeleteTap(context, note, deleteDirectly: shouldAsk),
    );
  }

  static Future<void> onDeleteTap(BuildContext context, Note note,
      {bool deleteDirectly = true}) async {
    var choice = true;
    if (!deleteDirectly) {
      choice = await showDialog<bool>(
              context: context,
              builder: (_) {
                return MyAlertDialog(
                  title: Text(Languages.of(context).message),
                  content: Text(Languages.of(context).deleteNotePermanently),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(Languages.of(context).alertDialogOp1),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(Languages.of(context).alertDialogOp2),
                    )
                  ],
                );
              }) ??
          false;
    }
    if (choice) {
      final value = await Provider.of<NotesHelper>(context, listen: false)
          .deleteNoteHelper(note);
      if (value) {
        Utilities.showSnackbar(
          context,
          Languages.of(context).done,
        );
      } else {
        Utilities.showSnackbar(
          context,
          Languages.of(context).error,
        );
      }
    }
  }

  static Widget trashAction(BuildContext context, Note note) {
    return IconSlideAction(
      icon: Icons.delete_outline,
      caption: Languages.of(context).trash,
      color: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
      //light
      onTap: () => onTrashTap(context, note),
    );
  }

  static Future<void> onTrashTap(BuildContext context, Note note) async {
    final value = await Provider.of<NotesHelper>(context, listen: false)
        .trashNoteHelper(note);
    if (value) {
      Utilities.showSnackbar(
        context,
        Languages.of(context).done,
      );
    } else {
      Utilities.showSnackbar(
        context,
        Languages.of(context).error,
      );
    }
  }

  static Widget copyAction(BuildContext context, Note note) {
    return IconSlideAction(
      icon: TablerIcons.copy,
      caption: Languages.of(context).copy,
      color: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
      //dark
      onTap: () => onCopyTap(context, note),
    );
  }

  static Future<void> onCopyTap(BuildContext context, Note note) async {
    final value = await Provider.of<NotesHelper>(context, listen: false)
        .copyNoteHelper(note);
    if (value) {
      Utilities.showSnackbar(
        context,
        Languages.of(context).done,
      );
    } else {
      Utilities.showSnackbar(
        context,
        Languages.of(context).error,
      );
    }
  }

  static Widget archiveAction(BuildContext context, Note note) {
    return IconSlideAction(
      icon: Icons.archive_outlined,
      caption: Languages.of(context).archive,
      color: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
      //light

      onTap: () => onArchiveTap(context, note),
    );
  }

  static Future<void> onArchiveTap(BuildContext context, Note note) async {
    final value = await Provider.of<NotesHelper>(context, listen: false)
        .archiveNoteHelper(note);
    if (value) {
      Utilities.showSnackbar(
        context,
        Languages.of(context).done,
      );
    } else {
      Utilities.showSnackbar(
        context,
        Languages.of(context).error,
      );
    }
  }

  static Widget unHideAction(BuildContext context, Note note) {
    return IconSlideAction(
      icon: Icons.drive_file_move_outline,
      caption: Languages.of(context).unhide,
      color: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
      //light

      onTap: () => onUnHideTap(context, note),
    );
  }

  static Future<void> onUnHideTap(BuildContext context, Note note) async {
    final value = await Provider.of<NotesHelper>(context, listen: false)
        .unhideNoteHelper(note);
    if (value) {
      Utilities.showSnackbar(
        context,
        Languages.of(context).done,
      );
    } else {
      Utilities.showSnackbar(
        context,
        Languages.of(context).error,
      );
    }
  }

  static Widget unArchiveAction(BuildContext context, Note note) {
    return IconSlideAction(
      icon: Icons.unarchive_outlined,
      caption: Languages.of(context).unarchive,
      color: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
      onTap: () => onUnArchiveTap(context, note),
    );
  }

  static Future<void> onUnArchiveTap(BuildContext context, Note note) async {
    final value = await Provider.of<NotesHelper>(context, listen: false)
        .unarchiveNoteHelper(note);
    if (value) {
      Utilities.showSnackbar(
        context,
        Languages.of(context).done,
      );
    } else {
      Utilities.showSnackbar(
        context,
        Languages.of(context).error,
      );
    }
  }

  static Widget restoreAction(BuildContext context, Note note) {
    return IconSlideAction(
      icon: Icons.restore_from_trash_outlined,
      caption: Languages.of(context).restore,
      color: Colors.transparent,
      foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
      //light

      onTap: () => onRestoreTap(context, note),
    );
  }

  static Future<void> onRestoreTap(BuildContext context, Note note) async {
    final value = await Provider.of<NotesHelper>(context, listen: false)
        .undeleteHelper(note);
    if (value) {
      Utilities.showSnackbar(
        context,
        Languages.of(context).done,
      );
    } else {
      Utilities.showSnackbar(
        context,
        Languages.of(context).error,
      );
    }
  }

  static Future<void> onDeleteAllTap(BuildContext context) async {
    final value = await Provider.of<NotesHelper>(context, listen: false)
        .deleteAllTrashNotesHelper();
    if (value) {
      Utilities.showSnackbar(
        context,
        Languages.of(context).done,
      );
    } else {
      Utilities.showSnackbar(
        context,
        Languages.of(context).error,
      );
    }
  }

  static Color iconColor() {
    switch (selectedIconColorStatus) {
      case IconColorStatus.RandomColor:
        return getRandomColor();

      case IconColorStatus.PickedColor:
        return selectedIconColor;

      case IconColorStatus.UiColor:
        return selectedPrimaryColor;

      default:
        return selectedAppTheme == AppTheme.Light ? Colors.black : Colors.white;
    }
  }

  static Future<void> addStringToSF(String key, String value) async {
    await prefs.setString(key, value);
  }

  static Future<void> addBoolToSF(String key, {required bool value}) async {
    await prefs.setBool(key, value);
  }

  static Future<void> addIntToSF(String key, int value) async {
    await prefs.setInt(key, value);
  }

  static Future<void> addDoubleToSF(String key, double value) async {
    await prefs.setDouble(key, value);
  }

  static String? getStringValuesSF(String key) {
    return prefs.getString(key);
  }

  static bool? getBoolValuesSF(String key) {
    return prefs.getBool(key);
  }

  static int? getIntValuesSF(String key) {
    return prefs.getInt(key);
  }

  static double? getDoubleValuesSF(String key) {
    return prefs.getDouble(key);
  }

  static Future<void> removeValues(String key) async {
    await prefs.remove(key);
  }

  static bool checkKey(String key) {
    return prefs.containsKey(key);
  }
}
