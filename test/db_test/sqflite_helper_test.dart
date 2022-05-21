import 'package:notes/_aap_packages.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

void sqfliteTestInit() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

final noteData = <String, dynamic>{
  'title': 'Note Title1',
  'content': 'Note Content',
  'lastModify': DateTime.now().millisecondsSinceEpoch,
  'state': 1,
};

Future<List<Map<String, dynamic>>> queryDB() async {
  return SqfliteHelper.queryData(
    whereStr: 'state = ?',
    whereCond: [1],
  );
}

Future<void> main() async {
  sqfliteTestInit();

  group(
    'SQFLite Tests',
    () => {
      test('Test DB is created', () async {
        final db = await SqfliteHelper.database;
        final result = await db.rawQuery(
          '''
        SELECT name FROM pragma_table_list('${SqfliteHelper.tableName}')
        ''',
        );
        expect(await db.getVersion(), dbVersion);
        expect(result[0]['name'], SqfliteHelper.tableName);
        await SqfliteHelper.deleteDB();
      }),
      test('Test SQFLite insert', () async {
        final note = Note.fromMap(noteData);
        var status = await SqfliteHelper.insert(note);
        var result = await queryDB();
        expect(status, true);
        expect(result.length, 1);
        status = await SqfliteHelper.insert(note);
        result = await queryDB();
        expect(status, true);
        expect(result.length, 1);
        await SqfliteHelper.deleteDB();
      })
    },
  );
}
