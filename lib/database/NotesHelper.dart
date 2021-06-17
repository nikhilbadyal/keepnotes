import 'package:notes/_appPackages.dart';
import 'package:notes/_externalPackages.dart';
import 'package:notes/_internalPackages.dart';

class NotesHelper with ChangeNotifier {
  List _mainNotes = [];
  List _otherNotes = [];

  List get mainNotes => [..._mainNotes];

  List get otherNotes => [..._otherNotes];

  Future<Note> insertNoteHelper(Note note,
      {bool isNew = false, bool shouldNotify = true, Database? testDb}) async {
    final copiedNote = note.copyWith(id: note.id);

    if (copiedNote.state == NoteState.hidden) {
      encryption.encrypt(copiedNote);
    }
    if (!isNew) {
      if (copiedNote.state == NoteState.unspecified) {
        final index = _mainNotes.indexWhere((element) {
          element as Note;
          return element.id == copiedNote.id;
        });
        _mainNotes.removeAt(index);
      } else {
        final index = _otherNotes.indexWhere((element) {
          element as Note;
          return element.id == copiedNote.id;
        });
        _otherNotes.removeAt(index);
      }
    }
    copiedNote.state == NoteState.unspecified
        ? _mainNotes.insert(0, note)
        : _otherNotes.insert(0, note);
    if (shouldNotify) {
      notifyListeners();
    }
    await DatabaseHelper.insertNoteDb(copiedNote, isNew: isNew, testDb: testDb);
    note.id = copiedNote.id;
    return note;
  }

  Future<bool> copyNoteHelper(Note note, {Database? testDb}) async {
    if (note.id != -1) {
      final copiedNote = note.copyWith(
        lastModify: DateTime.now(),
      );
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
          ? _mainNotes.removeWhere((element) {
              element as Note;
              return element.id == note.id;
            })
          : _otherNotes.removeWhere((element) {
              element as Note;
              return element.id == note.id;
            });
      await DatabaseHelper.archiveNoteDb(note, testDb: testDb);

      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> hideNoteHelper(Note note, {Database? testDb}) async {
    if (note.id != -1) {
      final copiedNote = note.copyWith(id: note.id);
      encryption.encrypt(copiedNote);
      note.state == NoteState.unspecified
          ? _mainNotes.removeWhere((element) {
              element as Note;
              return element.id == note.id;
            })
          : _otherNotes.removeWhere((element) {
              element as Note;
              return element.id == note.id;
            });
      await DatabaseHelper.hideNoteDb(copiedNote, testDb: testDb);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> unhideNoteHelper(Note note, {Database? testDb}) async {
    if (note.id != -1) {
      _mainNotes.add(note);
      _otherNotes.removeWhere((element) {
        element as Note;
        return element.id == note.id;
      });
      await DatabaseHelper.unhideNoteDb(note, testDb: testDb);

      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> unarchiveNoteHelper(Note note, {Database? testDb}) async {
    if (note.id != -1) {
      _mainNotes.add(note);
      _otherNotes.removeWhere((element) {
        element as Note;
        return element.id == note.id;
      });
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
    _otherNotes.removeWhere((element) {
      element as Note;
      return element.id == note.id;
    });
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
          ? _mainNotes.removeWhere((element) {
              element as Note;
              return element.id == note.id;
            })
          : _otherNotes.removeWhere((element) {
              element as Note;
              return element.id == note.id;
            });
      status = await DatabaseHelper.deleteNoteDb(note, testDb: testDb);
    } on Exception catch (_) {
      return false;
    }
    notifyListeners();
    return status;
  }

  Future<bool> trashNoteHelper(Note note, {Database? testDb}) async {
    var stat = false;
    if (note.id != -1) {
      note.state == NoteState.unspecified
          ? _mainNotes.removeWhere((element) {
              element as Note;
              return element.id == note.id;
            })
          : _otherNotes.removeWhere((element) {
              element as Note;
              return element.id == note.id;
            });
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
        final note = Note(
          title: itemVar['title'].toString(),
          content: itemVar['content'].toString(),
          lastModify: DateTime.fromMillisecondsSinceEpoch(
            itemVar['lastModify'],
          ),
          state: NoteState.values[itemVar['state']],
        );
        if (note.state == NoteState.hidden) {
          note.state = NoteState.unspecified;
          encryption.decrypt(note);
        }
        return note;
      },
    ).toList();
    return items;
  }

  Future<bool> addAllNotesToDatabaseHelper(List<Note> notesList,
      {Database? testDb}) async {
    final status = await DatabaseHelper.addAllNotesToBackupDb(notesList);
    notifyListeners();
    return status;
  }

  Future<void> encryptAllHidden() async {
    final notes = await DatabaseHelper.getAllNotesDb(NoteState.hidden.index);
    final notesList = notes
        .map(
          (itemVar) => Note(
            id: itemVar['id'],
            title: itemVar['title'].toString(),
            content: itemVar['content'].toString(),
            lastModify: DateTime.fromMillisecondsSinceEpoch(
              itemVar['lastModify'],
            ),
            state: NoteState.values[itemVar['state']],
          ),
        )
        .toList();
    for (final notes in notesList) {
      encryption.encrypt(notes);
      await DatabaseHelper.insertNoteDb(notes);
    }
  }

  Future getAllNotesHelper(int noteState, {Database? testDb}) async {
    final notesList =
        await DatabaseHelper.getAllNotesDb(noteState, testDb: testDb);
    noteState == NoteState.unspecified.index
        ? _mainNotes = notesList
            .map(
              (itemVar) => Note(
                id: itemVar['id'],
                title: itemVar['title'].toString(),
                content: itemVar['content'].toString(),
                lastModify: DateTime.fromMillisecondsSinceEpoch(
                  itemVar['lastModify'],
                ),
                state: NoteState.values[itemVar['state']],
              ),
            )
            .toList()
        : _otherNotes = notesList
            .map(
              (itemVar) => Note(
                id: itemVar['id'],
                title: itemVar['title'].toString(),
                content: itemVar['content'].toString(),
                lastModify: DateTime.fromMillisecondsSinceEpoch(
                  itemVar['lastModify'],
                ),
                state: NoteState.values[itemVar['state']],
              ),
            )
            .toList();
    if (noteState == NoteState.hidden.index) {
      _otherNotes.forEach((element) {
        encryption.decrypt(element);
      });
    }
  }

  Future<bool> recryptEverything(String password) async {
    try {
      final notesList = await DatabaseHelper.getAllNotesDb(
        NoteState.hidden.index,
      );
      final myList = notesList
          .map(
            (itemVar) => Note(
              id: itemVar['id'],
              title: itemVar['title'].toString(),
              content: itemVar['content'].toString(),
              lastModify: DateTime.fromMillisecondsSinceEpoch(
                itemVar['lastModify'],
              ),
              state: NoteState.values[itemVar['state']],
            ),
          )
          .toList();
      // ignore: cascade_invocations
      myList.forEach((element) {
        encryption.decrypt(element);
      });
      encryption.resetDetails(password);
      for (final note in myList) {
        encryption.encrypt(note);
        await DatabaseHelper.encryptNotesDb(note);
      }
    } on Exception catch (_) {
      return false;
    }
    return true;
  }

  Future<bool> autoMateEverything() async {
    try {
      final notesList = await DatabaseHelper.getAllNotesDb(
        NoteState.hidden.index,
      );
      final myList = notesList
          .map(
            (itemVar) => Note(
              id: itemVar['id'],
              title: itemVar['title'].toString(),
              content: itemVar['content'].toString(),
              lastModify: DateTime.fromMillisecondsSinceEpoch(
                itemVar['lastModify'],
              ),
              state: NoteState.values[itemVar['state']],
            ),
          )
          .toList();
      try {
        myList.forEach((element) {
          encryption.decrypt(element);
        });
      } on Exception catch (_) {}

      for (final note in myList) {
        encryption.encrypt(note);
        await DatabaseHelper.encryptNotesDb(note);
      }
    } on Exception catch (_) {
      return false;
    }
    return true;
  }
}
