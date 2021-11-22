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
  List<Note> mainNotes = [];

  int _page = 1;
  bool isLastPage = false;
  bool isLoading = false;

  void signOut() {
    mainNotes.clear();
  }

  static int comp(final Note obj1, final Note obj2) {
    return obj1.id.compareTo(obj2.id);
  }

  Future<void> insert(final Note note) async {
    final copiedNote = note.copyWith(id: note.id);
    if (copiedNote.state == NoteState.hidden) {
      encryption.encrypt(copiedNote);
    }
    mainNotes
      ..removeWhere((final element) {
        return element.id == note.id;
      })
      ..insert(0, note);
    unawaited(
        SqfliteDatabaseHelper.insert(copiedNote).then((final value) async {
      await FirebaseDatabaseHelper.insert(copiedNote);
    }));
    notifyListeners();
  }

  Future<bool> copy(final Note note) async {
    final copiedNote = note.copyWith(
      id: const Uuid().v4(),
      lastModify: DateTime.now(),
    );
    mainNotes.insert(0, copiedNote);
    notifyListeners();
    unawaited(
        SqfliteDatabaseHelper.insert(copiedNote).then((final value) async {
      await FirebaseDatabaseHelper.insert(copiedNote);
    }));
    return true;
  }

  Future<bool> archive(final Note note) async {
    mainNotes.removeWhere((final element) {
      return element.id == note.id;
    });
    note.state = NoteState.archived;
    unawaited(SqfliteDatabaseHelper.update(note).then((final value) async {
      await FirebaseDatabaseHelper.update(note);
    }));
    notifyListeners();
    return true;
  }

  Future<bool> hide(final Note note) async {
    final copiedNote = note.copyWith(id: note.id, state: NoteState.hidden);
    encryption.encrypt(copiedNote);
    mainNotes.removeWhere((final element) {
      return element.id == note.id;
    });
    unawaited(
        SqfliteDatabaseHelper.update(copiedNote).then((final value) async {
      await FirebaseDatabaseHelper.update(copiedNote);
    }));
    notifyListeners();
    return true;
  }

  Future<bool> unhide(final Note note) async {
    mainNotes.removeWhere((final element) {
      return element.id == note.id;
    });
    note.state = NoteState.unspecified;
    unawaited(SqfliteDatabaseHelper.update(note).then((final value) async {
      await FirebaseDatabaseHelper.update(note);
    }));
    notifyListeners();
    return true;
  }

  Future<bool> unarchive(final Note note) async {
    mainNotes.removeWhere((final element) {
      return element.id == note.id;
    });
    note.state = NoteState.unspecified;
    unawaited(SqfliteDatabaseHelper.update(note).then((final value) async {
      await FirebaseDatabaseHelper.update(note);
    }));
    notifyListeners();
    return true;
  }

  Future<bool> undelete(final Note note) async {
    mainNotes.removeWhere((final element) {
      return element.id == note.id;
    });
    note.state = NoteState.unspecified;
    unawaited(SqfliteDatabaseHelper.update(note).then((final value) async {
      await FirebaseDatabaseHelper.update(note);
    }));
    notifyListeners();
    return true;
  }

  Future<bool> delete(final Note note) async {
    try {
      mainNotes.removeWhere((final element) {
        return element.id == note.id;
      });
      unawaited(SqfliteDatabaseHelper.delete('id = ?', [note.id])
          .then((final value) async {
        await FirebaseDatabaseHelper.delete(NoteOperation.delete, note);
      }));
    } on Exception catch (_) {
      return false;
    }
    notifyListeners();
    return true;
  }

  Future<bool> trash(final Note note) async {
    final orig = note.state.index;
    mainNotes.removeWhere((final element) {
      return element.id == note.id;
    });
    note.state = NoteState.deleted;
    unawaited(SqfliteDatabaseHelper.update(note).then((final value) async {
      await getAllNotes(orig);
      await FirebaseDatabaseHelper.update(note);
    }));
    notifyListeners();
    return true;
  }

  Future<bool> deleteAllHidden() async {
    await SqfliteDatabaseHelper.delete('state = ?', [NoteState.hidden.index]);
    await FirebaseDatabaseHelper.batchDelete('state',
        isEqualTo: [NoteState.hidden.index]);
    notifyListeners();
    return true;
  }

  void emptyTrash() {
    mainNotes.clear();
    unawaited(
        SqfliteDatabaseHelper.delete('state = ?', [NoteState.deleted.index])
            .then((final _) {
      unawaited(FirebaseDatabaseHelper.batchDelete('state', isEqualTo: 4));
    }));
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> myGetAll() async {
    final notesList = await FirebaseDatabaseHelper.getAll();
    final items = notesList.docs.map((final e) => e.data()).toList();
    return items;
  }

  Future<void> encryptAllHidden() async {
    final notes = await SqfliteDatabaseHelper.queryData(
        whereCond: [NoteState.hidden.index]);
    final notesList = notes
        .map(
          (final itemVar) => Note(
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

  Future getAllNotes(final int noteState) async {
    if (!isLastPage && !isLoading) {
      isLoading = true;
      if (!SqfliteDatabaseHelper.syncedWithFirebase) {
        await SqfliteDatabaseHelper.addAll(await myGetAll());
        SqfliteDatabaseHelper.syncedWithFirebase = true;
        unawaited(addBoolToSF('syncedWithFirebase', value: true));
      }
      const limit = 15;
      final offSet = _page == 1 ? 0 : (_page - 1) * limit;
      final notesList = await SqfliteDatabaseHelper.queryData(
        whereStr: 'state = ?',
        whereCond: [noteState],
        limit: limit,
        offSet: offSet,
      );
      isLastPage = notesList.isEmpty || notesList.length < limit;
      if (!isLastPage) {
        _page++;
      }
      isLoading = false;
      mainNotes = [
        ...mainNotes,
        ...List.from(notesList.map(
          (final itemVar) {
            final item = Note(
              id: itemVar['id'],
              title: noteState == NoteState.hidden.index
                  ? encryption.decryptStr(itemVar['title'])
                  : itemVar['title'].toString(),
              content: noteState == NoteState.hidden.index
                  ? encryption.decryptStr(itemVar['content'])
                  : itemVar['content'].toString(),
              lastModify: DateTime.fromMillisecondsSinceEpoch(
                itemVar['lastModify'],
              ),
              state: NoteState.values[itemVar['state']],
            );
            return item;
          },
        ).toList())
      ];

      if (noteState == NoteState.hidden.index) {
        // ignore: prefer_foreach
        for (final element in mainNotes) {
          encryption.decrypt(element);
        }
      }
    }
  }

  Future<bool> recryptEverything(final String password) async {
    try {
      final notesList = await SqfliteDatabaseHelper.queryData(
          whereStr: 'state = ?', whereCond: [NoteState.hidden.index]);
      final myList = notesList
          .map(
            (final itemVar) => Note(
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

  void reset() {
    mainNotes.clear();
    _page = 1;
    isLastPage = isLoading = false;
  }
}
