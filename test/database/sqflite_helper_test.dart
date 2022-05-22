import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

import 'note_data.dart';

void sqfliteTestInit() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

Future<List<Map<String, dynamic>>> queryDB({
  final String? whereStr,
  final List<Object>? whereCond,
  final int? limit,
  final int? offSet,
  final String? orderBy,
}) async {
  final db = await SqfliteHelper.database;
  return db.query(
    SqfliteHelper.tableName,
    orderBy: orderBy,
    where: whereStr,
    whereArgs: whereCond,
    limit: limit,
    offset: offSet,
  );
}

const totalNotes = 20;

Future<void> main() async {
  sqfliteTestInit();
  final notes = getRandomNotes(total: totalNotes);
  group(
    'SQFLite Tests - ',
    () => {
      test('Test DB is created', () async {
        await SqfliteHelper.deleteDB();
        final db = await SqfliteHelper.database;
        final result = await db.rawQuery(
          '''
        SELECT name FROM sqlite_master WHERE type='table' AND name='${SqfliteHelper.tableName}'
        ''',
        );
        expect(await db.getVersion(), dbVersion);
        expect(result[0]['name'], SqfliteHelper.tableName);
        await SqfliteHelper.deleteDB();
      }),
      test('Test SQFLite insert', () async {
        final note = Note.fromMap(notes[0]);
        var status = await SqfliteHelper.insert(note);
        var result = await queryDB();
        expect(status, true);
        expect(result.length, 1);
        status = await SqfliteHelper.insert(note);
        result = await queryDB();
        expect(status, true);
        expect(result.length, 1);
        await SqfliteHelper.deleteDB();
      }),
      test('Test SQFLite Bulk insert', () async {
        final status = await SqfliteHelper.batchInsert(notes);
        final result = await queryDB(orderBy: 'id');
        expect(status, true);
        expect(result.length, totalNotes);
      }),
      test('Test SQFLite queryData', () async {
        var result = await SqfliteHelper.queryData();
        expect(result.length, totalNotes);
        result = await SqfliteHelper.queryData(limit: 2);
        expect(result.length, 2);
        result = await SqfliteHelper.queryData(
          whereStr: 'id = ?',
          args: [notes[3]['id'] as String],
        );
        expect(result[0], notes[3]);
        result = await SqfliteHelper.queryData(
          orderBy: 'lastModify',
        );
        expect(
          int.parse(
            result[1]['lastModify'].toString(),
          ),
          greaterThanOrEqualTo(
            int.parse(
              result[0]['lastModify'].toString(),
            ),
          ),
        );
      }),
      test('Test SQFLite delete', () async {
        var result = await queryDB();
        expect(result.length, totalNotes);
        var status =
            await SqfliteHelper.delete('id = ?', [result[0]['id'].toString()]);
        result = await queryDB();
        expect(status, true);
        expect(result.length, 19);
        status = await SqfliteHelper.delete('id = ?', ['a']);
        result = await queryDB();
        expect(status, false);
        expect(result.length, 19);
        await SqfliteHelper.deleteDB();
      }),
    },
  );
}
