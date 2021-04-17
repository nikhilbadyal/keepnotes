import 'dart:async';

import 'package:notes/app.dart';
import 'package:notes/model/note.dart';
import 'package:notes/util/DatabaseExceptions.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// ignore: avoid_classes_with_only_static_members
class DatabaseHelper {
  static String tableName = 'notes';

  static final fieldMap = {
    'id': 'INTEGER PRIMARY KEY ',
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
          onCreate: (database, version) {
        return database.execute(
          query(),
        );
      }, version: 1);
    }
    return _database;
  }

  static String query() {
    var query = 'CREATE TABLE '; //IF NOT EXISTS
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
    } catch (e) {
      // debugPrint(e.toString());
      return false;
    }
  }

  static Future<bool> insertNoteDb(Note note,
      {bool isNew = false, Database? testDb}) async {
    final db = testDb ?? await database;
    try {
      note.id = await db.insert(
        tableName,
        isNew ? note.toMap(isNew: true) : note.toMap(isNew: false),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on Error {
      throw DatabaseExceptions('1');
    }
    return true;
  }

  static Future<bool> archiveNoteDb(Note note, {Database? testDb}) async {
    if (note.id != -1) {
      final db = testDb ?? await database;
      note.state = NoteState.archived;
      try {
        await db.update(
          'notes',
          note.toMap(isNew: false),
          where: 'id = ?',
          whereArgs: [note.id],
        );
      } on Error {
        throw DatabaseExceptions('2');
      }
      return true;
    }
    return false;
  }

  static Future<bool> hideNoteDb(Note note, {Database? testDb}) async {
    if (note.id != -1) {
      final db = testDb ?? await database;
      note.state = NoteState.hidden;
      final idToUpdate = note.id;
      try {
        await db.update(
          'notes',
          note.toMap(isNew: false),
          where: 'id = ?',
          whereArgs: [idToUpdate],
        );
      } on Error {
        throw DatabaseExceptions('3');
      }
      return true;
    }
    return false;
  }

  static Future<bool> unhideNoteDb(Note note, {Database? testDb}) async {
    if (note.id != -1) {
      final db = testDb ?? await database;
      note.state = NoteState.unspecified;
      final idToUpdate = note.id;
      try {
        await db.update(
          'notes',
          note.toMap(isNew: false),
          where: 'id = ?',
          whereArgs: [idToUpdate],
        );
      } on Error {
        throw DatabaseExceptions('4');
      }
      return true;
    }
    return false;
  }

  static Future<bool> unarchiveNoteDb(Note note, {Database? testDb}) async {
    if (note.id != -1) {
      final db = testDb ?? await database;
      note.state = NoteState.unspecified;
      final idToUpdate = note.id;

      try {
        await db.update(
          'notes',
          note.toMap(isNew: false),
          where: 'id = ?',
          whereArgs: [idToUpdate],
        );
      } on Error {
        throw DatabaseExceptions('5');
      }
      return true;
    }
    return false;
  }

  static Future<bool> undeleteDb(Note note, {Database? testDb}) async {
    if (note.id != -1) {
      final db = testDb ?? await database;
      note.state = NoteState.unspecified;
      final idToUpdate = note.id;

      try {
        await db.update(
          'notes',
          note.toMap(isNew: false),
          where: 'id = ?',
          whereArgs: [idToUpdate],
        );
      } on Error {
        throw DatabaseExceptions('5');
      }
      return true;
    }
    return false;
  }

  static Future<bool> deleteNoteDb(Note note, {Database? testDb}) async {
    if (note.id != -1) {
      final db = testDb ?? await database;
      try {
        final rowsEffected = await db.delete(
          'notes',
          where: 'id = ?',
          whereArgs: [note.id],
        );
        return rowsEffected != 0;
      } on Error {
        throw DatabaseExceptions('6');
      }
    }
    return false;
  }

  static Future<bool> trashNoteDb(Note note, {Database? testDb}) async {
    final db = testDb ?? await database;
    note.state = NoteState.deleted;
    final idToUpdate = note.id;

    try {
      await db.update(
        'notes',
        note.toMap(isNew: false),
        where: 'id = ?',
        whereArgs: [idToUpdate],
      );
    } on Error {
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
      myNotes.lockChecker.passwordSet = false;
      myNotes.lockChecker.updateDetails();
      return true;
    } on Error {
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
    } on Error {
      throw DatabaseExceptions('8');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllNotesDb(int noteState,
      {Database? testDb}) async {
    final db = testDb ?? await database;
    // ignore: prefer_typing_uninitialized_variables
    late final resultSet;
    try {
      resultSet = db.query(
        'notes',
        orderBy: 'lastModify desc',
        where: 'state = ?',
        whereArgs: [noteState],
      );
    } on Error {
      throw DatabaseExceptions('9');
    }
    return resultSet;
  }

  static Future<List<Map<String, dynamic>>> getNotesAllForBackupDb(
      {Database? testDb}) async {
    final db = testDb ?? await database;
    // ignore: prefer_typing_uninitialized_variables
    late final resultSet;
    try {
      resultSet = db.query('notes', orderBy: 'lastModify desc');
    } on Error {
      throw DatabaseExceptions('9');
    }
    return resultSet;
  }
/*static Future<bool> addAllNotesToBackupDb(Map<String, dynamic> jsonList) async {
    try {
      for (final note in notes) {
        await insertNoteDb(note, isNew: true);
      }
      return true;
    } catch (_) {
      return false;
    }
  }*/
}
