import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:test/test.dart';

import '../note_data.dart';

const totalNotes = 20;

void firebaseTestInit() {
  FirebaseHelper.db = FakeFirebaseFirestore();
  FirebaseHelper(const Uuid().v4());
}

Future<void> main() async {
  final notes = getRandomNotes(total: totalNotes);
  firebaseTestInit();
  group(
    'Firebase Tests - ',
    () => {
      test('Insert note', () async {
        final note = Note.fromMap(notes[0]);
        await FirebaseHelper.insert(note);
        var result = await FirebaseHelper.getAll();
        expect(result.docs.length, 1);
        const newTitle = 'Modified Title';
        note.title = newTitle;
        await FirebaseHelper.insert(note);
        result = await FirebaseHelper.getAll();
        expect(result.docs.length, 1);
        expect(result.docs[0]['title'], newTitle);
        final state = NoteState.trashed.index;
        note.state = NoteState.values[state];
        await FirebaseHelper.insert(note);
        result = await FirebaseHelper.getAll();
        expect(result.docs.length, 1);
        expect(result.docs[0]['state'], NoteState.trashed.index);
      }),
    },
  );
}
