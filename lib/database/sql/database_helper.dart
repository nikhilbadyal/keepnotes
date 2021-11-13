import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static String tableName = 'notes';

  static final fieldMap = {
    'id': 'text PRIMARY KEY ',
    'title': 'text',
    'content': 'text',
    'lastModify': 'INTEGER',
    'state': 'INTEGER',
  };

  static late Database _database;

  static Future<Database> get database async {
    final databasePath = await getDatabasesPath();
    final status = await databaseExists(databasePath);
    if (!status) {
      _database = await openDatabase(join(databasePath, 'notes_database.db'),
          onCreate: (database, version) => database.execute(
                query(),
              ),
          version: 1);
    }
    return _database;
  }

  static String query() {
    var query = 'CREATE TABLE ';
    query += tableName;
    query += '(';
    fieldMap.forEach((key, value) {
      query += '$key $value,';
    });

    query = query.substring(0, query.length - 1);
    query += ')';
    return query;
  }

  static Future<bool> addAllNotesToBackupDb(List<Note> jsonList) async {
    try {
      for (final note in jsonList) {
        await insertNoteDb(note, isNew: true);
      }
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  static Future<bool> insertNoteDb(Note note,
      {bool isNew = false, Database? testDb}) async {
    final db = testDb ?? await database;
    try {
      await db.insert(
        tableName,
        note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on Exception catch (_) {
      throw DatabaseExceptions('1');
    }
    return true;
  }

  static Future<bool> archiveNoteDb(Note note, {Database? testDb}) async {
    final db = testDb ?? await database;
    note.state = NoteState.archived;
    try {
      await db.update(
        'notes',
        note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id],
      );
    } on Exception catch (_) {
      throw DatabaseExceptions('2');
    }
    return true;
  }

  static Future<bool> hideNoteDb(Note note, {Database? testDb}) async {
    final db = testDb ?? await database;
    note.state = NoteState.hidden;
    final idToUpdate = note.id;
    try {
      await db.update(
        'notes',
        note.toMap(),
        where: 'id = ?',
        whereArgs: [idToUpdate],
      );
    } on Exception catch (_) {
      throw DatabaseExceptions('3');
    }
    return true;
  }

  static Future<bool> unhideNoteDb(Note note, {Database? testDb}) async {
    final db = testDb ?? await database;
    note.state = NoteState.unspecified;
    final idToUpdate = note.id;
    try {
      await db.update(
        'notes',
        note.toMap(),
        where: 'id = ?',
        whereArgs: [idToUpdate],
      );
    } on Exception catch (_) {
      throw DatabaseExceptions('4');
    }
    return false;
  }

  static Future<bool> unarchiveNoteDb(Note note, {Database? testDb}) async {
    final db = testDb ?? await database;
    note.state = NoteState.unspecified;
    final idToUpdate = note.id;

    try {
      await db.update(
        'notes',
        note.toMap(),
        where: 'id = ?',
        whereArgs: [idToUpdate],
      );
    } on Exception catch (_) {
      throw DatabaseExceptions('5');
    }
    return true;
  }

  static Future<bool> undeleteDb(Note note, {Database? testDb}) async {
    final db = testDb ?? await database;
    note.state = NoteState.unspecified;
    final idToUpdate = note.id;

    try {
      await db.update(
        'notes',
        note.toMap(),
        where: 'id = ?',
        whereArgs: [idToUpdate],
      );
    } on Exception catch (_) {
      throw DatabaseExceptions('5');
    }
    return true;
  }

  static Future<bool> deleteNoteDb(Note note, {Database? testDb}) async {
    final db = testDb ?? await database;
    try {
      final rowsEffected = await db.delete(
        'notes',
        where: 'id = ?',
        whereArgs: [note.id],
      );
      return rowsEffected != 0;
    } on Exception catch (_) {
      throw DatabaseExceptions('6');
    }
  }

  static Future<bool> trashNoteDb(Note note, {Database? testDb}) async {
    final db = testDb ?? await database;
    note.state = NoteState.deleted;
    final idToUpdate = note.id;

    try {
      await db.update(
        'notes',
        note.toMap(),
        where: 'id = ?',
        whereArgs: [idToUpdate],
      );
    } on Exception catch (_) {
      throw DatabaseExceptions('6');
    }

    return true;
  }

  static Future<bool> encryptNotesDb(Note note, {Database? testDb}) async {
    final db = testDb ?? await database;
    final idToUpdate = note.id;
    try {
      await db.update(
        'notes',
        note.toMap(),
        where: 'id = ?',
        whereArgs: [idToUpdate],
      );
    } on Exception catch (_) {
      throw DatabaseExceptions('6');
    }

    return true;
  }

  static Future<bool> deleteAllHiddenNotesDb({Database? testDb}) async {
    final db = testDb ?? await database;
    try {
      await db.delete(
        'notes',
        where: 'state = ?',
        whereArgs: [3],
      );

      return true;
    } on Exception catch (_) {
      throw DatabaseExceptions('7');
    }
  }

  static Future<bool> deleteAllTrashNoteDb({Database? testDb}) async {
    final db = testDb ?? await database;
    try {
      await db.delete(
        'notes',
        where: 'state = ?',
        whereArgs: [NoteState.deleted.index],
      );
      return true;
    } on Exception catch (_) {
      throw DatabaseExceptions('8');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllNotesDb(int noteState,
      {Database? testDb}) async {
    final db = testDb ?? await database;
    late Future<List<Map<String, Object?>>> resultSet;
    try {
      resultSet = db.query(
        'notes',
        orderBy: 'lastModify desc',
        where: 'state = ?',
        whereArgs: [noteState],
      );
    } on Exception catch (_) {
      throw DatabaseExceptions('9');
    }
    return resultSet;
  }

  static Future<List<Map<String, dynamic>>> getNotesAllForBackupDb(
      {Database? testDb}) async {
    final db = testDb ?? await database;
    late Future<List<Map<String, Object?>>> resultSet;
    try {
      resultSet = db.query('notes', orderBy: 'lastModify desc');
    } on Exception catch (_) {
      throw DatabaseExceptions('9');
    }
    return resultSet;
  }
}
