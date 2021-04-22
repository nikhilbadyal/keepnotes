import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/model/Note.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/screen/MoreOptionsMenu.dart';
import 'package:notes/util/AppConfiguration.dart';
import 'package:notes/util/Languages/Languages.dart';
import 'package:notes/util/Utilites.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({required this.currentNote, this.shouldAutoFocus = false});

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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        appBar: appbar(context),
        body: _body(context),
        bottomSheet: _bottomBar(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
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
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
              decoration: InputDecoration(
                  hintText: Languages.of(context).enterNoteTitle,
                  border: InputBorder.none),
            ),
            TextField(
              //TODO fix this issue . 1
              autofocus: widget.shouldAutoFocus,
              readOnly: isReadOnly,
              controller: _contentController,
              maxLines: null,
              showCursor: true,
              style: const TextStyle(
                fontSize: 15.0,
              ),
              // TODO fix this 3
              /*onChanged: (value) {
                final counter = Provider.of<CharCount>(context, listen: false);
                counter.change(value.length);
              },*/
              decoration: InputDecoration(
                  hintText: Languages.of(context).enterNoteContent,
                  border: InputBorder.none),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
  }

  Widget _bottomBar(BuildContext context) {
    return BottomAppBar(
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
                  ? selectedPrimaryColor
                  : selectedAppTheme == AppTheme.Light
                      ? Colors.black
                      : Colors.white,
            ),
            Center(
              child: Text(
                '${Languages.of(context).modified} ${noteInEditing.strLastModifiedDate1}',
              ),
            ),
            IconButton(
              onPressed: () async {
                await backgroundSaveNote();
                if (noteInEditing.content.isEmpty &&
                    noteInEditing.title.isEmpty) {
                  Utilities.showSnackbar(
                      context, Languages.of(context).emptyNote);
                  // Navigator.of(context).pop();
                } else {
                  _moreMenu(context);
                }
              },
              icon: const Icon(Icons.more_vert_outlined),
              color: Utilities.iconColor(),
              tooltip: Languages.of(context).more,
            ),
          ],
        ),
      ),
    );
  }

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
          Languages.of(context).emptyNoteDiscarded,
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
        Languages.of(context).emptyNoteDiscarded,
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

  AppBar appbar(BuildContext context) {
    return AppBar(
      leading: BackButton(
        onPressed: _onAppLeadingBackPress,
        color: Colors.white,
      ),
      elevation: 1,
    );
  }

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
      builder: (context) {
        return Wrap(
          children: [
            MoreOptionsMenu(
              note: noteInEditing,
              saveNote: backgroundSaveNote,
              autoSaver: autoSaverTimer,
            ),
          ],
        );
      },
    );
  }

  void onPressed() {
    setState(() {
      // ignore: parameter_assignments
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
