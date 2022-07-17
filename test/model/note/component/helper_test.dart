import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

import '../../../database/note_data.dart';

void setup() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  encryption = Encrypt(randomString(length: 32));
  FirebaseHelper.db = FakeFirebaseFirestore();
  FirebaseHelper(randomString(length: 32));
}

const totalNotes = 20;
Future<void> main() async {
  setup();
  final notes = getRandomNotes(total: totalNotes);
  group('Notes Helper Test - ', () {
    final notesHelper = NotesHelper();
    test('Insert Note', () async {
      await SqfliteHelper.deleteDB();
      final note1 = Note.fromMap(notes[0]);
      await notesHelper.insert(note1);
      expect(notesHelper.mainNotes.contains(note1), true);
      expect(notesHelper.mainNotes.length, 1);
      note1.title = 'Modified Title';
      await notesHelper.insert(note1);
      expect(notesHelper.mainNotes.contains(note1), true);
      expect(notesHelper.mainNotes.length, 1);
      final note2 = Note.fromMap(notes[10])..state = NoteState.hidden;
      await notesHelper.insert(note2);
      expect(notesHelper.mainNotes.contains(note2), true);
      expect(notesHelper.mainNotes.length, 2);
      expect(notesHelper.mainNotes[0], note2);
      expect(notesHelper.mainNotes[1], note1);
    });
  });
}
