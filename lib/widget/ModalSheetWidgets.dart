import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:notes/model/Languages.dart';
import 'package:notes/model/Note.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/util/AppConfiguration.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/LockManager.dart';
import 'package:notes/util/Utilities.dart';
import 'package:notes/widget/AlertDialog.dart';
import 'package:provider/provider.dart';

class ModalSheetUnhideWidget extends StatelessWidget {
  const ModalSheetUnhideWidget({
    required this.note,
    required this.autoSaver,
    required this.saveNote,
    Key? key,
  }) : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  Widget build(BuildContext context) => Flexible(
        fit: FlexFit.tight,
        child: GestureDetector(
          onTap: () {

            autoSaver.cancel();
            saveNote();
            final wantedRoute = getRoute(note.state);
            Utilities.onUnHideTap(context, note);
            Navigator.of(context).popUntil(
              (route) => route.settings.name == wantedRoute,
            );
          },
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).iconTheme.color!.withOpacity(0.1),
                width: 1.5,
              ),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  color: Colors.black.withOpacity(0.04),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.drive_file_move_outline,
                  size: 35,
                  color: Provider.of<AppConfiguration>(context, listen: false)
                      .iconColor,
                ),
                const SizedBox(width: 16),
                Text(Language.of(context).unhide),
              ],
            ),
          ),
        ),
      );
}

class ModalSheetArchiveWidget extends StatelessWidget {
  const ModalSheetArchiveWidget({
    required this.note,
    required this.autoSaver,
    required this.saveNote,
    Key? key,
  }) : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  Widget build(BuildContext context) => Flexible(
        fit: FlexFit.tight,
        child: GestureDetector(
          onTap: () {
            autoSaver.cancel();
            saveNote();
            final wantedRoute = getRoute(note.state);
            Utilities.onArchiveTap(context, note);
            Navigator.of(context).popUntil(
              (route) => route.settings.name == wantedRoute,
            );
          },
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).iconTheme.color!.withOpacity(0.1),
                width: 1.5,
              ),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  color: Colors.black.withOpacity(0.04),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.archive_outlined,
                  size: 35,
                  color: Provider.of<AppConfiguration>(context, listen: false)
                      .iconColor,
                ),
                const SizedBox(width: 16),
                Text(Language.of(context).archive),
              ],
            ),
          ),
        ),
      );
}

class ModalSheetCopyToClipBoardWidget extends StatelessWidget {
  const ModalSheetCopyToClipBoardWidget({
    required this.note,
    required this.autoSaver,
    required this.saveNote,
    Key? key,
  }) : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  Widget build(BuildContext context) => Flexible(
        fit: FlexFit.tight,
        child: GestureDetector(
          onTap: () async {
            autoSaver.cancel();
            saveNote();
            Navigator.of(context).pop();
            await Clipboard.setData(
              ClipboardData(text: note.title),
            );
            await Clipboard.setData(
              ClipboardData(text: note.content),
            ).then(
              (value) => Utilities.showSnackbar(
                  context, Language.of(context).done,
                  snackBarBehavior: SnackBarBehavior.floating),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(left: 8),
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).iconTheme.color!.withOpacity(0.1),
                width: 1.5,
              ),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  color: Colors.black.withOpacity(0.04),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  TablerIcons.copy,
                  size: 35,
                  color: Provider.of<AppConfiguration>(context, listen: false)
                      .iconColor,
                ),
                const SizedBox(width: 16),
                Text(Language.of(context).clipboard)
              ],
            ),
          ),
        ),
      );
}

class ModalSheetTrashWidget extends StatelessWidget {
  const ModalSheetTrashWidget({
    required this.note,
    required this.autoSaver,
    required this.saveNote,
    Key? key,
  }) : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  Widget build(BuildContext context) => Flexible(
        fit: FlexFit.tight,
        child: GestureDetector(
          onTap: () {
            autoSaver.cancel();
            saveNote();
            final wantedRoute = getRoute(note.state);
            Utilities.onTrashTap(context, note);
            Navigator.of(context).popUntil(
              (route) => route.settings.name == wantedRoute,
            );
          },
          child: Container(
            margin: const EdgeInsets.only(left: 8),
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).iconTheme.color!.withOpacity(0.1),
                width: 1.5,
              ),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  color: Colors.black.withOpacity(0.04),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete_outlined,
                  size: 35,
                  color: Provider.of<AppConfiguration>(context, listen: false)
                      .iconColor,
                ),
                const SizedBox(width: 16),
                Text(Language.of(context).trash)
              ],
            ),
          ),
        ),
      );
}

class ModalSheetHideWidget extends StatelessWidget {
  const ModalSheetHideWidget({
    required this.note,
    required this.autoSaver,
    required this.saveNote,
    Key? key,
  }) : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  Widget build(BuildContext context) => Flexible(
        fit: FlexFit.tight,
        child: GestureDetector(
          onTap: () async {
            final status = Provider.of<LockChecker>(context, listen: false)
                .password
                .isNotEmpty;
            if (!status) {
              await showDialog(
                barrierDismissible: true,
                context: context,
                builder: (_) => MyAlertDialog(
                  title: Text(Language.of(context).message),
                  content: Text(Language.of(context).setPasswordFirst),
                ),
              );
            } else {
              autoSaver.cancel();
              saveNote();
              final wantedRoute = getRoute(note.state);
              await Utilities.onHideTap(context, note);
              Navigator.of(context).popUntil(
                (route) => route.settings.name == wantedRoute,
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).iconTheme.color!.withOpacity(0.1),
                width: 1.5,
              ),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  color: Colors.black.withOpacity(0.04),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  TablerIcons.ghost,
                  size: 35,
                  color: Provider.of<AppConfiguration>(context, listen: false)
                      .iconColor,
                ),
                const SizedBox(width: 16),
                Text(Language.of(context).hide),
              ],
            ),
          ),
        ),
      );
}

class ModalSheetUnarchiveWidget extends StatelessWidget {
  const ModalSheetUnarchiveWidget({
    required this.note,
    required this.autoSaver,
    required this.saveNote,
    Key? key,
  }) : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  Widget build(BuildContext context) => Flexible(
        fit: FlexFit.tight,
        child: GestureDetector(
          onTap: () {
            autoSaver.cancel();
            saveNote();
            final wantedRoute = getRoute(note.state);
            Utilities.onUnArchiveTap(context, note);
            Navigator.of(context).popUntil(
              (route) => route.settings.name == wantedRoute,
            );
          },
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).iconTheme.color!.withOpacity(0.1),
                width: 1.5,
              ),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  color: Colors.black.withOpacity(0.04),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.unarchive_outlined,
                  size: 35,
                  color: Provider.of<AppConfiguration>(context, listen: false)
                      .iconColor,
                ),
                const SizedBox(width: 16),
                Text(Language.of(context).unarchive),
              ],
            ),
          ),
        ),
      );
}

class ModalSheetDeleteAllWidget extends StatelessWidget {
  const ModalSheetDeleteAllWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Flexible(
        fit: FlexFit.tight,
        child: GestureDetector(
          onTap: () async {
            final status = await showDialog<bool>(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) => MyAlertDialog(
                    title: Text(Language.of(context).message),
                    content: Text(Language.of(context).emptyTrashWarning),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(Language.of(context).alertDialogOp1),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text(Language.of(context).alertDialogOp2),
                      ),
                    ],
                  ),
                ) ??
                false;
            if (status) {
              if (Provider.of<NotesHelper>(context, listen: false)
                  .otherNotes
                  .isNotEmpty) {
                await Utilities.onDeleteAllTap(context);
              }
            }
            Navigator.of(context).popUntil(
                (route) => route.settings.name == AppRoutes.trashScreen);
          },
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).iconTheme.color!.withOpacity(0.1),
                width: 1.5,
              ),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  color: Colors.black.withOpacity(0.04),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  TablerIcons.trash,
                  size: 35,
                  color: Provider.of<AppConfiguration>(context, listen: false)
                      .iconColor,
                ),
                const SizedBox(width: 16),
                Text(Language.of(context).emptyTrash),
              ],
            ),
          ),
        ),
      );
}

String getRoute(NoteState state) {
  switch (state) {
    case NoteState.archived:
      return AppRoutes.archiveScreen;

    case NoteState.hidden:
      return AppRoutes.hiddenScreen;

    default:
      return AppRoutes.homeScreen;
  }
}
