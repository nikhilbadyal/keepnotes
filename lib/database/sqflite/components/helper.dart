// ignore_for_file: avoid_classes_with_only_static_members

import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

enum DBOperations { insert, update, delete }

class SqfliteHelper {
  static String tableName = 'notes';
  static String dbName = 'notes_database.db';
  static late Database _database;
  static late String dbPath;
  static final fieldMap = {
    'id': 'text PRIMARY KEY ',
    'title': 'text',
    'content': 'text',
    'lastModify': 'INTEGER',
    'state': 'INTEGER',
  };

  static Future<bool> dbExists() async {
    final databasePath = await getDatabasesPath();
    dbPath = join(databasePath, dbName);
    return databaseExists(dbPath);
  }

  static Future<Database> get database async {
    final status = await dbExists();
    if (!status) {
      _database = await openDatabase(
        dbPath,
        onCreate: (final database, final version) => database.execute(
          _query(),
        ),
        version: dbVersion,
      );
    }
    return _database;
  }

  static String _query() {
    var query = 'CREATE TABLE ';
    query += tableName;
    query += '(';
    fieldMap.forEach((final key, final value) {
      query += '$key $value,';
    });
    query = query.substring(0, query.length - 1);
    query += ')';
    return query;
  }

  static void _queryStatus(final int noOfRows, final DBOperations operation) {
    if (noOfRows == 0) {
      throw SqfliteException(
        errorCode: 'E${operation.index}',
        errorDetails: 'Sqflite note ${operation.name} failed',
      );
    }
  }

  static Future<bool> insert(final Note note) async {
    final db = await database;
    await db.insert(
      tableName,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }

  static Future<bool> delete(
    final String whereCond,
    final List<Object> where,
  ) async {
    final db = await database;
    var isSuccess = true;

    try {
      final status = await db.delete(
        tableName,
        where: whereCond,
        whereArgs: where,
      );
      _queryStatus(status, DBOperations.delete);
    } on Exception {
      isSuccess = false;
      logger.wtf('Sqflite note delete failed');
    }
    return isSuccess;
  }

  static Future<List<Map<String, dynamic>>> queryData({
    final String? whereStr,
    final List<Object>? args,
    final int? limit,
    final int? offSet,
    final String? orderBy,
  }) async {
    final db = await database;
    var resultSet = <Map<String, Object?>>[];
    try {
      resultSet = await db.query(
        tableName,
        orderBy: orderBy,
        where: whereStr,
        whereArgs: args,
        limit: limit,
        offset: offSet,
      );
    } on Exception {
      logger.wtf('Sqflite queryData failed');
    }
    return resultSet;
  }

  static Future<bool> batchInsert(
    final List<Map<String, dynamic>> notesList, {
    final ConflictAlgorithm? conflictAlgorithm,
  }) async {
    final db = await database;
    final batch = db.batch();
    for (final element in notesList) {
      batch.insert(tableName, element, conflictAlgorithm: conflictAlgorithm);
    }
    await batch.commit(noResult: true, continueOnError: false);
    return true;
  }

  static Future<bool> deleteDB() async {
    final status = await dbExists();
    if (status) {
      await deleteDatabase(
        dbPath,
      );
      return true;
    }
    return false;
  }
}
