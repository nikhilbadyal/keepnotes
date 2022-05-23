import 'package:notes/_aap_packages.dart';
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

  Future<bool> signOut() async {
    reset();
    await FirebaseHelper.terminateDB();
    return await SqfliteHelper.deleteDB() &&
        await removeFromSF('syncedWithFirebase');
  }

  void notify() {
    notifyListeners();
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
      SqfliteHelper.insert(copiedNote).then(
        (final value) async => FirebaseHelper.insert(copiedNote),
      ),
    );
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
      SqfliteHelper.insert(copiedNote).then((final value) async {
        await FirebaseHelper.insert(copiedNote);
      }),
    );
    return true;
  }

  Future<bool> archive(final Note note) async {
    mainNotes.removeWhere((final element) {
      return element.id == note.id;
    });
    note.state = NoteState.archived;
    unawaited(
      SqfliteHelper.insert(note).then((final value) async {
        await FirebaseHelper.insert(note);
      }),
    );
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
      SqfliteHelper.insert(copiedNote).then((final value) async {
        await FirebaseHelper.insert(copiedNote);
      }),
    );
    notifyListeners();
    return true;
  }

  Future<bool> unhide(final Note note) async {
    mainNotes.removeWhere((final element) {
      return element.id == note.id;
    });
    note.state = NoteState.unspecified;
    unawaited(
      SqfliteHelper.insert(note).then((final value) async {
        await FirebaseHelper.insert(note);
      }),
    );
    notifyListeners();
    return true;
  }

  Future<bool> unarchive(final Note note) async {
    mainNotes.removeWhere((final element) {
      return element.id == note.id;
    });
    note.state = NoteState.unspecified;
    unawaited(
      SqfliteHelper.insert(note).then((final value) async {
        await FirebaseHelper.insert(note);
      }),
    );
    notifyListeners();
    return true;
  }

  Future<bool> undelete(final Note note) async {
    mainNotes.removeWhere((final element) {
      return element.id == note.id;
    });
    note.state = NoteState.unspecified;
    unawaited(
      SqfliteHelper.insert(note).then((final value) async {
        await FirebaseHelper.insert(note);
      }),
    );
    notifyListeners();
    return true;
  }

  Future<bool> delete(final Note note) async {
    try {
      mainNotes.removeWhere((final element) {
        return element.id == note.id;
      });
      unawaited(
        SqfliteHelper.delete('id = ?', [note.id]).then((final value) async {
          await FirebaseHelper.delete(note);
        }),
      );
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
    note.state = NoteState.trashed;
    unawaited(
      SqfliteHelper.insert(note).then((final value) async {
        await getAllNotes(orig);
        await FirebaseHelper.insert(note);
      }),
    );
    notifyListeners();
    return true;
  }

  Future<bool> deleteAllHidden() async {
    await SqfliteHelper.delete('state = ?', [NoteState.hidden.index]);
    await FirebaseHelper.batchDelete(
      'state',
      isEqualTo: [NoteState.hidden.index],
    );
    notifyListeners();
    return true;
  }

  void emptyTrash() {
    mainNotes.clear();
    unawaited(
      SqfliteHelper.delete('state = ?', [NoteState.trashed.index])
          .then((final _) {
        unawaited(
          FirebaseHelper.batchDelete(
            'state',
            isEqualTo: NoteState.trashed.index,
          ),
        );
      }),
    );
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getFromFirebase() async {
    try {
      final notesList = await FirebaseHelper.getAll();
      final items = notesList.docs
          .map(
            (final e) => e.data(),
          )
          .toList();
      unawaited(
        addBoolToSF('syncedWithFirebase', value: true),
      );
      return items;
    } catch (_) {
      return [];
    }
  }

  Future<void> getAllNotes(final int noteState) async {
    if (!isLastPage && !isLoading) {
      isLoading = true;
      if (!(getBoolFromSF('syncedWithFirebase') ?? false)) {
        await SqfliteHelper.batchInsert(
          await getFromFirebase(),
        );
      }
      final offSet = _page == 1 ? 0 : (_page - 1) * pageLimit;
      final notesList = await SqfliteHelper.queryData(
        whereStr: 'state = ?',
        args: [noteState],
        limit: pageLimit,
        offSet: offSet,
        orderBy: 'lastModify desc',
      );
      isLastPage = notesList.isEmpty || notesList.length < pageLimit;
      if (!isLastPage) {
        _page++;
      }
      isLoading = false;
      mainNotes = [
        ...mainNotes,
        ...List.from(
          notesList.map(
            (final itemVar) {
              final item = NoteX.emptyNote.copyWith(
                id: itemVar['id'].toString(),
                title: noteState == NoteState.hidden.index
                    ? encryption.decryptStr(itemVar['title'].toString())
                    : itemVar['title'].toString(),
                content: noteState == NoteState.hidden.index
                    ? encryption.decryptStr(itemVar['content'].toString())
                    : itemVar['content'].toString(),
                lastModify: DateTime.fromMillisecondsSinceEpoch(
                  int.parse(itemVar['lastModify'].toString()),
                ),
                state: NoteState.values[int.parse(
                  itemVar['state'].toString(),
                )],
              );
              return item;
            },
          ).toList(),
        )
      ];
    }
  }

  List<Map<String, dynamic>> makeModifiableResults(
    final List<Map<String, dynamic>> results,
  ) {
    return List<Map<String, dynamic>>.generate(
      results.length,
      (final index) => Map<String, dynamic>.from(results[index]),
    );
  }

  void reset() {
    mainNotes.clear();
    _page = 1;
    isLastPage = isLoading = false;
  }
}
