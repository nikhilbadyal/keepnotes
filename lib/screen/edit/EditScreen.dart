import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:notes/model/Languages.dart';
import 'package:notes/model/Note.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/screen/edit/MoreOptionsMenu.dart';
import 'package:notes/util/AppConfiguration.dart';
import 'package:notes/util/Utilities.dart';
import 'package:notes/util/pdf/CreatePdf.dart';
import 'package:notes/widget/AlertDialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  const EditScreen(
      {required this.currentNote, this.shouldAutoFocus = false, Key? key})
      : super(key: key);

  final Note currentNote;
  final bool shouldAutoFocus;

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  bool isReadOnly = false;
  late Note noteInEditing;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool isNew = false;
  late final String _titleFromInitial;
  late final String _contentFromInitial;
  late String oldName;
  late Timer autoSaverTimer;

  @override
  void initState() {
    super.initState();
    noteInEditing = widget.currentNote;
    _titleController.text = noteInEditing.title;
    _contentController.text = noteInEditing.content;
    _titleFromInitial = widget.currentNote.title;
    _contentFromInitial = widget.currentNote.content;
    if (widget.currentNote.id == -1) {
      isNew = true;
    }
    autoSaverTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      backgroundSaveNote();
    });
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: _onBackPress,
        child: Scaffold(
          appBar: appbar(context),
          body: _body(context),
          bottomSheet: _bottomBar(context),
        ),
      );

  Widget _body(BuildContext context) => Container(
        padding: const EdgeInsets.only(
            bottom: kBottomNavigationBarHeight, left: 10, right: 10),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              TextField(
                readOnly: isReadOnly,
                controller: _titleController,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                    hintText: Language.of(context).enterNoteTitle,
                    border: InputBorder.none),
              ),
              TextField(
                //TODO fix this issue . 1
                autofocus: noteInEditing.id == -1,
                readOnly: isReadOnly,
                controller: _contentController,
                maxLines: null,
                showCursor: true,
                style: const TextStyle(
                  fontSize: 15,
                ),
                // TODO fix this 3
                /*onChanged: (value) {
                final counter =
                Provider.of<CharCount>(context, listen: false);
                counter.change(value.length);
              },*/
                decoration: InputDecoration(
                    hintText: Language.of(context).enterNoteContent,
                    border: InputBorder.none),
              ),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
  }

  Widget _bottomBar(BuildContext context) => BottomAppBar(
        child: Container(
          color: Theme.of(context).canvasColor,
          height: kBottomNavigationBarHeight,
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.lock_outline),
                onPressed: onPressed,
                color: isReadOnly
                    ? Provider.of<AppConfiguration>(context, listen: false)
                        .primaryColor
                    : Provider.of<AppConfiguration>(context, listen: false)
                                .appTheme ==
                            AppTheme.Light
                        ? Colors.black
                        : Colors.white,
              ),
              Center(
                child: Text(
                  '${Language.of(context).modified} '
                  '${noteInEditing.strLastModifiedDate1}',
                ),
              ),
              IconButton(
                onPressed: () async {
                  await backgroundSaveNote();
                  if (noteInEditing.content.isEmpty &&
                      noteInEditing.title.isEmpty) {
                    Utilities.showSnackbar(
                        context, Language.of(context).emptyNote);
                  } else {
                    _moreMenu(context);
                  }
                },
                icon: const Icon(Icons.more_vert_outlined),
                color: Provider.of<AppConfiguration>(context, listen: false)
                    .iconColor,
                tooltip: Language.of(context).more,
              ),
            ],
          ),
        ),
      );

  Future<bool> _onBackPress() async {
    autoSaverTimer.cancel();
    await saveNote();
    return true;
  }

  Future<bool> _onAppLeadingBackPress() async {
    autoSaverTimer.cancel();
    await saveNote();
    Navigator.of(context).pop();
    return true;
  }

  Future<bool> saveNote() async {
    final isEdited = updateNote();
    final isEmptyNote = isEmpty();
    if (isEdited) {
      if (isEmptyNote) {
        await Provider.of<NotesHelper>(context, listen: false)
            .deleteNoteHelper(noteInEditing);
        Utilities.showSnackbar(
          context,
          Language.of(context).emptyNoteDiscarded,
          duration: const Duration(milliseconds: 100),
        );
        return false;
      }
      if (noteInEditing.id == -1) {
        await Provider.of<NotesHelper>(context, listen: false)
            .insertNoteHelper(noteInEditing, isNew: true);
      } else {
        await Provider.of<NotesHelper>(context, listen: false)
            .insertNoteHelper(noteInEditing);
      }
      return true;
    }
    if (isEmptyNote) {
      await Provider.of<NotesHelper>(context, listen: false)
          .deleteNoteHelper(noteInEditing);
      Utilities.showSnackbar(
        context,
        Language.of(context).emptyNoteDiscarded,
      );
    }
    return false;
  }

  Future<void> backgroundSaveNote() async {
    final isEdited = updateNote();
    if (isEdited) {
      if (noteInEditing.id == -1) {
        await Provider.of<NotesHelper>(context, listen: false)
            .insertNoteHelper(noteInEditing, isNew: true);
      } else {
        await Provider.of<NotesHelper>(context, listen: false)
            .insertNoteHelper(noteInEditing);
      }
    }
  }

  bool updateNote() {
    noteInEditing.title = _titleController.text.trim();
    // ignore: cascade_invocations
    noteInEditing.content = _contentController.text.trim();
    if (!(noteInEditing.title == _titleFromInitial &&
        noteInEditing.content == _contentFromInitial)) {
      noteInEditing.lastModify = DateTime.now();
      return true;
    }
    return false;
  }

  bool isEmpty() {
    if (noteInEditing.title.isEmpty && noteInEditing.content.isEmpty) {
      return true;
    }
    return false;
  }

  Future<void> exitWithoutSaving(BuildContext context) async {
    autoSaverTimer.cancel();
    Navigator.pop(context);
  }

  AppBar appbar(BuildContext context) => AppBar(
        leading: BackButton(
          onPressed: _onAppLeadingBackPress,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (noteInEditing.title.isEmpty &&
                  noteInEditing.content.isEmpty) {
                Utilities.showSnackbar(context, Language.of(context).emptyNote);
                return;
              }
              if (await Utilities.requestPermission(Permission.storage)) {
                await saveNote();
                await HapticFeedback.vibrate();
                await PdfUtils.createPdf(context, noteInEditing);
                Utilities.showSnackbar(context, Language.of(context).done);
              } else {
                await showDialog<void>(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) => MyAlertDialog(
                    title: Text(Language.of(context).error),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(Language.of(context).permissionError),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        child: Text(Language.of(context).alertDialogOp2),
                      ),
                    ],
                  ),
                );
              }
            },
            icon: const Icon(Icons.print),
          ),
        ],
        elevation: 1,
      );

  void _moreMenu(BuildContext context) {
    FocusScope.of(context).requestFocus(
      FocusNode(),
    );
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      context: context,
      builder: (context) => Wrap(
        children: [
          MoreOptionsMenu(
            note: noteInEditing,
            saveNote: backgroundSaveNote,
            autoSaver: autoSaverTimer,
          ),
        ],
      ),
    );
  }

  void onPressed() {
    setState(() {
      isReadOnly = !isReadOnly;
    });
  }
}

/*void _onChanged(String value) {
    final counter = Provider.of<CharCount>(context, listen: false);
    counter.change(value.length);
  }*/

/* List<Widget> _appbarAction(BuildContext context) {
    final actions = <Widget>[];
    actions.add(Consumer<CharCount>(
      builder: (context, counter, child) {
        return Padding(
          padding:  const EdgeInsets.only(top: 25, right: 10),
          child: Text(counter.textLength.toString()),
        );
      },
    ));
    return actions;
  }*/
