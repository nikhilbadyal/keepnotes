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

  Future<Note> insert(Note note) async {
    final copiedNote = note.copyWith(id: note.id);
    if (copiedNote.state == NoteState.hidden) {
      encryption.encrypt(copiedNote);
    }
    // This is because of background insertion
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
    await SqfliteDatabaseHelper.insert(copiedNote);
    await FirebaseDatabaseHelper.insert(copiedNote);
    note.id = copiedNote.id;
    return note;
  }

  Future<bool> copy(Note note) async {
    final copiedNote = note.copyWith(
      id: const Uuid().v4(),
      lastModify: DateTime.now(),
    );
    note.state == NoteState.unspecified
        ? mainNotes.add(copiedNote)
        : otherNotes.add(copiedNote);
    notifyListeners();
    await SqfliteDatabaseHelper.insert(copiedNote);
    await FirebaseDatabaseHelper.insert(copiedNote);
    return true;
  }

  Future<bool> archive(Note note) async {
    note.state == NoteState.unspecified
        ? mainNotes.removeWhere((element) {
            return element.id == note.id;
          })
        : otherNotes.removeWhere((element) {
            return element.id == note.id;
          });
    note.state = NoteState.archived;
    await SqfliteDatabaseHelper.update(note);
    await FirebaseDatabaseHelper.update(note);
    notifyListeners();
    return true;
  }

  Future<bool> hide(Note note) async {
    final copiedNote = note.copyWith(id: note.id);
    encryption.encrypt(copiedNote);
    note.state == NoteState.unspecified
        ? mainNotes.removeWhere((element) {
            return element.id == note.id;
          })
        : otherNotes.removeWhere((element) {
            return element.id == note.id;
          });
    note.state = NoteState.hidden;
    await SqfliteDatabaseHelper.update(copiedNote);
    await FirebaseDatabaseHelper.update(copiedNote);
    notifyListeners();
    return true;
  }

  Future<bool> unhide(Note note) async {
    mainNotes.add(note);
    otherNotes.removeWhere((element) {
      return element.id == note.id;
    });
    note.state = NoteState.unspecified;
    await SqfliteDatabaseHelper.update(note);
    await FirebaseDatabaseHelper.update(note);
    notifyListeners();
    return true;
  }

  Future<bool> unarchive(Note note) async {
    mainNotes.add(note);
    otherNotes.removeWhere((element) {
      return element.id == note.id;
    });
    note.state = NoteState.unspecified;
    await SqfliteDatabaseHelper.update(note);
    await FirebaseDatabaseHelper.update(note);
    notifyListeners();
    return true;
  }

  Future<bool> undelete(Note note) async {
    mainNotes.add(note);
    otherNotes.removeWhere((element) {
      return element.id == note.id;
    });
    note.state = NoteState.unspecified;
    await SqfliteDatabaseHelper.update(note);
    await FirebaseDatabaseHelper.update(note);
    notifyListeners();
    return true;
  }

  Future<bool> delete(Note note) async {
    try {
      note.state == NoteState.unspecified
          ? mainNotes.removeWhere((element) {
              return element.id == note.id;
            })
          : otherNotes.removeWhere((element) {
              return element.id == note.id;
            });
      await SqfliteDatabaseHelper.delete('id = ?', [note.id]);
      await FirebaseDatabaseHelper.delete(NoteOperation.delete, note);
    } on Exception catch (_) {
      return false;
    }
    notifyListeners();
    return true;
  }

  Future<bool> trash(Note note) async {
    note.state == NoteState.unspecified
        ? mainNotes.removeWhere((element) {
            return element.id == note.id;
          })
        : otherNotes.removeWhere((element) {
            return element.id == note.id;
          });
    note.state = NoteState.deleted;
    await SqfliteDatabaseHelper.update(note);
    await FirebaseDatabaseHelper.update(note);
    notifyListeners();
    return true;
  }

  Future<bool> deleteAllHidden() async {
    notifyListeners();
    await SqfliteDatabaseHelper.delete('state = ?', [NoteState.hidden.index]);
    await FirebaseDatabaseHelper.batchDelete('state',
        isEqualTo: [NoteState.hidden.index]);
    return true;
  }

  Future<bool> emptyTrash() async {
    otherNotes.clear();
    await SqfliteDatabaseHelper.delete('state = ?', [NoteState.deleted.index]);
    await FirebaseDatabaseHelper.batchDelete('state', isEqualTo: 4);
    notifyListeners();
    return true;
  }

  Future<List<Map<String, dynamic>>> myGetAll() async {
    final notesList = await FirebaseDatabaseHelper.getAll();
    final items = notesList.docs.map((e) => e.data()).toList();
    return items;
  }

  Future<void> encryptAllHidden() async {
    final notes = await SqfliteDatabaseHelper.queryData(
        whereCond: [NoteState.hidden.index]);
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
      await SqfliteDatabaseHelper.insert(notes);
      await FirebaseDatabaseHelper.insert(notes);
    }
  }

  Future getAllNotes(int noteState) async {
    final notesList = await SqfliteDatabaseHelper.queryData(
        whereStr: 'state = ?', whereCond: [noteState]);
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
      // ignore: prefer_foreach
      for (final element in otherNotes) {
        encryption.decrypt(element);
      }
    }
  }

  Future<bool> recryptEverything(String password) async {
    try {
      final notesList = await SqfliteDatabaseHelper.queryData(
          whereStr: 'state = ?', whereCond: [NoteState.hidden.index]);
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
        await SqfliteDatabaseHelper.update(note);
      }
    } on Exception catch (_) {
      return false;
    }
    return true;
  }
}
