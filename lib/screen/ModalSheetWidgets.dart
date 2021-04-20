import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:notes/app.dart';
import 'package:notes/model/Note.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/Utilites.dart';
import 'package:provider/provider.dart';

class ModalSheetUnhideWidget extends StatelessWidget {
  const ModalSheetUnhideWidget(
      {Key? key,
      required this.note,
      required this.autoSaver,
      required this.saveNote})
      : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  Widget build(BuildContext context) {
    return Flexible(
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
              Icon(Icons.drive_file_move_outline,
                  size: 35, color: Theme.of(context).accentColor),
              const SizedBox(width: 16),
              const Text('Unhide'),
            ],
          ),
        ),
      ),
    );
  }
}

class ModalSheetArchiveWidget extends StatelessWidget {
  const ModalSheetArchiveWidget(
      {Key? key,
      required this.note,
      required this.autoSaver,
      required this.saveNote})
      : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  Widget build(BuildContext context) {
    return Flexible(
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
              Icon(Icons.archive_outlined,
                  size: 35, color: Theme.of(context).accentColor),
              const SizedBox(width: 16),
              const Text('Archive'),
            ],
          ),
        ),
      ),
    );
  }
}

class ModalSheetCopyToClipBoardWidget extends StatelessWidget {
  const ModalSheetCopyToClipBoardWidget(
      {Key? key,
      required this.note,
      required this.autoSaver,
      required this.saveNote})
      : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  Widget build(BuildContext context) {
    return Flexible(
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
            (value) => Utilities.showSnackbar(context, 'Copied to Clipboard',
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
              Icon(TablerIcons.copy,
                  size: 35, color: Theme.of(context).accentColor),
              const SizedBox(width: 16),
              const Text('Clipboard')
            ],
          ),
        ),
      ),
    );
  }
}

class ModalSheetTrashWidget extends StatelessWidget {
  const ModalSheetTrashWidget(
      {Key? key,
      required this.note,
      required this.autoSaver,
      required this.saveNote})
      : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  Widget build(BuildContext context) {
    return Flexible(
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
              Icon(Icons.delete_outlined,
                  size: 35, color: Theme.of(context).accentColor),
              const SizedBox(width: 16),
              const Text('Trash')
            ],
          ),
        ),
      ),
    );
  }
}

class ModalSheetHideWidget extends StatelessWidget {
  const ModalSheetHideWidget(
      {Key? key,
      required this.note,
      required this.autoSaver,
      required this.saveNote})
      : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: GestureDetector(
        onTap: () async {
          final status = myNotes.lockChecker.passwordSet;
          if (!status) {
            await showDialog(
              context: context,
              builder: (_) {
                return const MySimpleDialog(
                  title: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Please set password first'),
                  ),
                );
              },
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
              Icon(TablerIcons.ghost,
                  size: 35, color: Theme.of(context).accentColor),
              const SizedBox(width: 16),
              const Text('Hide'),
            ],
          ),
        ),
      ),
    );
  }
}

class ModalSheetUnarchiveWidget extends StatelessWidget {
  const ModalSheetUnarchiveWidget(
      {Key? key,
      required this.note,
      required this.autoSaver,
      required this.saveNote})
      : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  Widget build(BuildContext context) {
    return Flexible(
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
              Icon(Icons.unarchive_outlined,
                  size: 35, color: Theme.of(context).accentColor),
              const SizedBox(width: 16),
              const Text('Unarchive'),
            ],
          ),
        ),
      ),
    );
  }
}

class ModalSheetDeleteAllWidget extends StatelessWidget {
  const ModalSheetDeleteAllWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: GestureDetector(
        onTap: () async {
          await showDialog<bool>(
            context: context,
            builder: (_) {
              return MyAlertDialog(
                title: const Text('Empty Trash'),
                content: const Text(
                    'This will remove all the content from trash permanently!'),
                actions: [
                  TextButton(
                    onPressed: () async {
                      if (Provider.of<NotesHelper>(context, listen: false)
                          .otherNotes
                          .isNotEmpty) {
                        await Utilities.onDeleteAllTap(context);
                      }
                      Navigator.of(context).popUntil((route) =>
                          route.settings.name == NotesRoutes.trashScreen);
                    },
                    child: const Text('Sure'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).popUntil(
                        (route) =>
                            route.settings.name == NotesRoutes.trashScreen,
                      );
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            },
          );
          // debugPrint('here');
          // await navigate('', context, NotesRoutes.trashScreen);
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
              Icon(TablerIcons.trash,
                  size: 35, color: Theme.of(context).accentColor),
              const SizedBox(width: 16),
              const Text('Empty Trash Permanently'),
            ],
          ),
        ),
      ),
    );
  }
}

String getRoute(NoteState state) {
  switch (state) {
    case NoteState.archived:
      return NotesRoutes.archiveScreen;

    case NoteState.hidden:
      return NotesRoutes.hiddenScreen;

    default:
      return NotesRoutes.homeScreen;
  }
}
