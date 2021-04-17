import 'package:flutter/material.dart';
import 'package:notes/model/database/database_helper.dart';
import 'package:notes/model/note.dart';
import 'package:sqflite/sqlite_api.dart';

class NotesHelper with ChangeNotifier {
  List _mainNotes = [];
  List _otherNotes = [];

  List get mainNotes => [..._mainNotes];

  List get otherNotes => [..._otherNotes];

  Future<Note> insertNoteHelper(Note note,
      {bool isNew = false, bool shouldNotify = true, Database? testDb}) async {
    if (!isNew) {
      if (note.state == NoteState.unspecified) {
        final index = _mainNotes.indexWhere((element) => element.id == note.id);
        _mainNotes.removeAt(index);
      } else {
        final index =
            _otherNotes.indexWhere((element) => element.id == note.id);
        _otherNotes.removeAt(index);
      }
    }
    note.state == NoteState.unspecified
        ? _mainNotes.insert(0, note)
        : _otherNotes.insert(0, note);
    if (shouldNotify) {
      notifyListeners();
    }
    await DatabaseHelper.insertNoteDb(note, isNew: isNew, testDb: testDb);
    return note;
  }

  Future<bool> copyNoteHelper(Note note, {Database? testDb}) async {
    if (note.id != -1) {
      final copiedNote = note.copyWith(lastModify: DateTime.now());
      note.state == NoteState.unspecified
          ? _mainNotes.insert(0, copiedNote)
          : _otherNotes.insert(0, copiedNote);
      notifyListeners();
      await DatabaseHelper.insertNoteDb(copiedNote,
          isNew: true, testDb: testDb);
      return true;
    }
    return false;
  }

  Future<bool> archiveNoteHelper(Note note, {Database? testDb}) async {
    if (note.id != -1) {
      note.state == NoteState.unspecified
          ? _mainNotes.removeWhere((element) => element.id == note.id)
          : _otherNotes.removeWhere((element) => element.id == note.id);
      await DatabaseHelper.archiveNoteDb(note, testDb: testDb);

      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> hideNoteHelper(Note note, {Database? testDb}) async {
    if (note.id != -1) {
      note.state == NoteState.unspecified
          ? _mainNotes.removeWhere((element) => element.id == note.id)
          : _otherNotes.removeWhere((element) => element.id == note.id);
      await DatabaseHelper.hideNoteDb(note, testDb: testDb);

      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> unhideNoteHelper(Note note, {Database? testDb}) async {
    if (note.id != -1) {
      _mainNotes.add(note);
      _otherNotes.removeWhere((element) => element.id == note.id);
      await DatabaseHelper.unhideNoteDb(note, testDb: testDb);

      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> unarchiveNoteHelper(Note note, {Database? testDb}) async {
    if (note.id != -1) {
      _mainNotes.add(note);
      _otherNotes.removeWhere((element) => element.id == note.id);
      await DatabaseHelper.unarchiveNoteDb(note, testDb: testDb);

      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> undeleteHelper(Note note, {Database? testDb}) async {
    if (note.id == -1) {
      return false;
    }
    _mainNotes.add(note);
    _otherNotes.removeWhere((element) => element.id == note.id);
    await DatabaseHelper.undeleteDb(note, testDb: testDb);

    notifyListeners();
    return true;
  }

  Future<bool> deleteNoteHelper(Note note, {Database? testDb}) async {
    var status = false;
    if (note.id == -1) {
      return status;
    }
    try {
      note.state == NoteState.unspecified
          ? _mainNotes.removeWhere((element) => element.id == note.id)
          : _otherNotes.removeWhere((element) => element.id == note.id);
      status = await DatabaseHelper.deleteNoteDb(note, testDb: testDb);
    } catch (_) {
      return false;
    }
    notifyListeners();
    return status;
  }

  Future<bool> trashNoteHelper(Note note, {Database? testDb}) async {
    var stat = false;
    if (note.id != -1) {
      note.state == NoteState.unspecified
          ? _mainNotes.removeWhere((element) => element.id == note.id)
          : _otherNotes.removeWhere((element) => element.id == note.id);
      stat = await DatabaseHelper.trashNoteDb(note, testDb: testDb);

      notifyListeners();
    }
    return stat;
  }

  Future<bool> deleteAllHiddenNotesHelper({Database? testDb}) async {
    notifyListeners();
    return DatabaseHelper.deleteAllHiddenNotesDb(testDb: testDb);
  }

  Future<bool> deleteAllTrashNotesHelper({Database? testDb}) async {
    _otherNotes.removeRange(0, _otherNotes.length);
    final status = await DatabaseHelper.deleteAllTrashNoteDb(testDb: testDb);

    notifyListeners();
    return status;
  }

  Future<List> getNotesAllForBackupHelper({Database? testDb}) async {
    final notesList =
        await DatabaseHelper.getNotesAllForBackupDb(testDb: testDb);
    final items = notesList.map(
      (itemVar) {
        return Note(
          id: itemVar['id'],
          title: itemVar['title'].toString(),
          content: itemVar['content'].toString(),
          lastModify: DateTime.fromMillisecondsSinceEpoch(
            itemVar['lastModify'],
          ),
          state: NoteState.values[itemVar['state']],
        );
      },
    ).toList();
    return items;
  }

  /*Future<bool> addAllNotesToDatabseHelper(Map<String, dynamic> jsonList) async {
    final status = await DatabaseHelper.addAllNotesToBackupDb(jsonList);
    notifyListeners();
    return status;
  }*/

  Future<bool> addAllNotesToDatabaseHelper(List<Note> notesList,
      {Database? testDb}) async {
    final status = await DatabaseHelper.addAllNotesToBackupDb(notesList);
    notifyListeners();
    return status;
  }

  Future getAllNotesHelper(int noteState, {Database? testDb}) async {
    // debugPrint('called');
    final notesList =
        await DatabaseHelper.getAllNotesDb(noteState, testDb: testDb);
    noteState == NoteState.unspecified.index
        ? _mainNotes = notesList.map(
            (itemVar) {
              return Note(
                id: itemVar['id'],
                title: itemVar['title'].toString(),
                content: itemVar['content'].toString(),
                lastModify: DateTime.fromMillisecondsSinceEpoch(
                  itemVar['lastModify'],
                ),
                state: NoteState.values[itemVar['state']],
              );
            },
          ).toList()
        : _otherNotes = notesList.map(
            (itemVar) {
              return Note(
                id: itemVar['id'],
                title: itemVar['title'].toString(),
                content: itemVar['content'].toString(),
                lastModify: DateTime.fromMillisecondsSinceEpoch(
                  itemVar['lastModify'],
                ),
                state: NoteState.values[itemVar['state']],
              );
            },
          ).toList();
  }

  void falseDelete() {
    // notifyListeners();
  }
}

class MySimpleDialog extends StatelessWidget {
  const MySimpleDialog(
      {Key? key, required this.title, this.children = const []})
      : super(key: key);

  final Widget title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Center(
        child: title,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      children: children,
    );
  }
}

class MyAlertDialog extends StatelessWidget {
  const MyAlertDialog(
      {Key? key, required this.title, this.actions, required this.content})
      : super(key: key);

  final Widget title;
  final List<Widget>? actions;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: content,
      actions: actions,
    );
  }
}
