// ignore_for_file: avoid_classes_with_only_static_members

import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

enum DBOperations { insert, update, delete }

class SqfliteHelper {
  static String tableName = 'notes';
  static String dbName = 'notes_database.db';
  static bool isSuccess = true;
  static late Database _database;

  static final fieldMap = {
    'id': 'text PRIMARY KEY ',
    'title': 'text',
    'content': 'text',
    'lastModify': 'INTEGER',
    'state': 'INTEGER',
  };

  static Future<Database> get database async {
    final databasePath = await getDatabasesPath();
    final status = await databaseExists(databasePath);
    if (!status) {
      _database = await openDatabase(
        join(databasePath, dbName),
        onCreate: (final database, final version) => database.execute(
          query(),
        ),
        version: dbVersion,
      );
    }
    return _database;
  }

  static String query() {
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

  static void queryStatus(final int noOfRows, final DBOperations operation) {
    if (noOfRows == 0) {
      isSuccess = false;
      throw SqfliteException(
        errorCode: 'E${operation.index}',
        errorDetails: 'Sqflite note ${operation.name} failed',
      );
    }
  }

  static Future<bool> insert(final Note note) async {
    final db = await database;
    try {
      final status = await db.insert(
        tableName,
        note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      queryStatus(status, DBOperations.insert);
    } on Exception {
      isSuccess = false;
      logger.wtf('Sqflite note insert failed');
    }
    return isSuccess;
  }

  static Future<bool> delete(
    final String whereCond,
    final List<Object> where,
  ) async {
    final db = await database;
    try {
      final status = await db.delete(
        tableName,
        where: whereCond,
        whereArgs: where,
      );
      queryStatus(status, DBOperations.delete);
    } on Exception {
      isSuccess = false;
      logger.wtf('Sqflite note delete failed');
    }
    return isSuccess;
  }

  static Future<List<Map<String, dynamic>>> queryData({
    final String? whereStr,
    final List<Object>? whereCond,
    final int? limit,
    final int? offSet,
  }) async {
    final db = await database;
    var resultSet = <Map<String, Object?>>[];
    try {
      resultSet = await db.query(
        tableName,
        orderBy: 'lastModify desc',
        where: whereStr,
        whereArgs: whereCond,
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
    try {
      final db = await database;
      final batch = db.batch();
      for (final element in notesList) {
        batch.insert(tableName, element, conflictAlgorithm: conflictAlgorithm);
      }
      await batch.commit(noResult: true, continueOnError: false);
    } on Exception {
      isSuccess = false;
      logger.wtf('Sqflite batch delete failed');
    }
    return isSuccess;
  }

  static Future<bool> deleteDB() async {
    try {
      final databasePath = await getDatabasesPath();
      await deleteDatabase(
        join(databasePath, dbName),
      );
    } on Exception {
      isSuccess = false;
      logger.wtf('Sqflite deleteDB failed');
    }
    return isSuccess;
  }
}
