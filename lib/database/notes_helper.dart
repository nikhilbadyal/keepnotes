import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

enum NoteOperation {
  insert,
  trash,
  unDelete,
  delete,
  copy,
  archive,
  unArchive,
  hide,
  unhide,
}

class NotesHelper with ChangeNotifier {
  SplayTreeSet<Note> mainNotes = SplayTreeSet();
  SplayTreeSet<Note> otherNotes = SplayTreeSet();

  Future<Note> insertNoteHelper(Note note, {Database? testDb}) async {
    final copiedNote = note.copyWith(id: note.id);

    if (copiedNote.state == NoteState.hidden) {
      encryption.encrypt(copiedNote);
    }
    if (copiedNote.state == NoteState.unspecified) {
      mainNotes.removeWhere((element) {
        return element.id == copiedNote.id;
      });
    } else {
      otherNotes.removeWhere((element) {
        return element.id == copiedNote.id;
      });
    }
    copiedNote.state == NoteState.unspecified
        ? mainNotes.add(note)
        : otherNotes.add(note);
    notifyListeners();
    await DatabaseHelper.insertNoteDb(copiedNote, testDb: testDb);
    note.id = copiedNote.id;
    return note;
  }

  Future<bool> copyNoteHelper(Note note, {Database? testDb}) async {
    final copiedNote = note.copyWith(
      id: const Uuid().v4(),
      lastModify: DateTime.now(),
    );
    note.state == NoteState.unspecified
        ? mainNotes.add(copiedNote)
        : otherNotes.add(copiedNote);
    notifyListeners();
    await DatabaseHelper.insertNoteDb(copiedNote, isNew: true, testDb: testDb);
    return true;
  }

  Future<bool> archiveNoteHelper(Note note, {Database? testDb}) async {
    note.state == NoteState.unspecified
        ? mainNotes.removeWhere((element) {
            return element.id == note.id;
          })
        : otherNotes.removeWhere((element) {
            return element.id == note.id;
          });
    await DatabaseHelper.archiveNoteDb(note, testDb: testDb);

    notifyListeners();
    return true;
  }

  Future<bool> hideNoteHelper(Note note, {Database? testDb}) async {
    final copiedNote = note.copyWith(id: note.id);
    encryption.encrypt(copiedNote);
    note.state == NoteState.unspecified
        ? mainNotes.removeWhere((element) {
            return element.id == note.id;
          })
        : otherNotes.removeWhere((element) {
            return element.id == note.id;
          });
    await DatabaseHelper.hideNoteDb(copiedNote, testDb: testDb);
    notifyListeners();
    return true;
  }

  Future<bool> unhideNoteHelper(Note note, {Database? testDb}) async {
    mainNotes.add(note);
    otherNotes.removeWhere((element) {
      return element.id == note.id;
    });
    await DatabaseHelper.unhideNoteDb(note, testDb: testDb);

    notifyListeners();
    return true;
  }

  Future<bool> unarchiveNoteHelper(Note note, {Database? testDb}) async {
    mainNotes.add(note);
    otherNotes.removeWhere((element) {
      return element.id == note.id;
    });
    await DatabaseHelper.unarchiveNoteDb(note, testDb: testDb);

    notifyListeners();
    return true;
  }

  Future<bool> undeleteHelper(Note note, {Database? testDb}) async {
    mainNotes.add(note);
    otherNotes.removeWhere((element) {
      return element.id == note.id;
    });
    await DatabaseHelper.undeleteDb(note, testDb: testDb);

    notifyListeners();
    return true;
  }

  Future<bool> deleteNoteHelper(Note note, {Database? testDb}) async {
    var status = false;
    try {
      note.state == NoteState.unspecified
          ? mainNotes.removeWhere((element) {
              return element.id == note.id;
            })
          : otherNotes.removeWhere((element) {
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
    note.state == NoteState.unspecified
        ? mainNotes.removeWhere((element) {
            return element.id == note.id;
          })
        : otherNotes.removeWhere((element) {
            return element.id == note.id;
          });
    stat = await DatabaseHelper.trashNoteDb(note, testDb: testDb);

    notifyListeners();
    return stat;
  }

  Future<bool> deleteAllHiddenNotesHelper({Database? testDb}) async {
    notifyListeners();
    return DatabaseHelper.deleteAllHiddenNotesDb(testDb: testDb);
  }

  Future<bool> deleteAllTrashNotesHelper({Database? testDb}) async {
    otherNotes.clear();
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
          // TODO Check this
          id: const Uuid().v4(),
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
        ? mainNotes = SplayTreeSet.from(notesList
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
            .toList())
        : otherNotes = SplayTreeSet.from(notesList
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
            .toList());
    if (noteState == NoteState.hidden.index) {
      for (final element in otherNotes) {
        encryption.decrypt(element);
      }
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
      for (var i = 0; i < myList.length; i++) {
        final element = myList[i];
        encryption.decrypt(element);
      }
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
        for (var i = 0; i < myList.length; i++) {
          final element = myList[i];
          encryption.decrypt(element);
        }
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
