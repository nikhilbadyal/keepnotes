import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';
import 'package:test/test.dart';

import '../note_data.dart';

const totalNotes = 20;

void firebaseTestInit() {
  FirebaseHelper.db = FakeFirebaseFirestore();
  FirebaseHelper(const Uuid().v4());
}

Future<void> main() async {
  final notes = getRandomNotes(total: totalNotes);
  var state = randomNumber().toString();
  final count = noOfStateNote(notes, state);

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
      test('Batch insert note', () async {
        await FirebaseHelper.batchInsert(notes);
        final result = await FirebaseHelper.getAll();
        expect(result.docs.length, 21);
      }),
      test('Delete note', () async {
        final note = Note.fromMap(notes[13])..id = notes[13]['id'].toString();
        var status = await FirebaseHelper.delete(note);
        expect(status, true);
        final result = await FirebaseHelper.getAll();
        expect(result.docs.length, 20);
        status = await FirebaseHelper.delete(note);
        expect(result.docs.length, 20);
      }),
      test('Batch delete note', () async {
        state = randomNumber().toString();
        await FirebaseHelper.batchDelete('state', isEqualTo: state);
        final result = await FirebaseHelper.getAll();
        expect(result.docs.length, 20 - count);
      }),
      test('Getall note', () async {
        final result = await FirebaseHelper.getAll();
        final stateNoteCount = noOfStateNoteInResult(result.docs, state);
        expect(stateNoteCount, 0);
      }),
    },
  );
}

int noOfStateNoteInResult(
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> data,
  final String state,
) {
  final items = data
      .map(
        (final e) => e.data(),
      )
      .toList();
  return noOfStateNote(items, state);
}

int noOfStateNote(final List<Map<String, dynamic>> notes, final String state) {
  var i = 0;
  var count = 0;
  while (i != notes.length) {
    if (notes[i]['id'] == state) {
      count++;
    }
    i++;
  }
  return count;
}
