import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

class FirebaseHelper {
  FirebaseHelper(final String uid) {
    _uid = uid;
    notesReference =
        db.collection(userCollection).doc(uid).collection(notesCollection);
  }

  static FirebaseFirestore db = FirebaseFirestore.instance;
  static String notesCollection = 'notes';
  static String userCollection = 'user';
  static late CollectionReference<Map<String, dynamic>> notesReference;
  static bool isSuccess = true;
  static late String _uid;

  static Future<void> insert(final Note note) async {
    await notesReference.doc(note.id).set(note.toMap());
  }

  static Future<void> batchInsert(
    final List<dynamic> notesList,
  ) async {
    final batch = db.batch();
    for (final note in notesList) {
      batch.set(
        db
            .collection(userCollection)
            .doc(_uid)
            .collection(notesCollection)
            .doc(note['id'].toString()),
        note,
      );
    }
    await batch.commit();
  }

  static Future<bool> delete(
    final Note note,
  ) async {
    await notesReference.doc(note.id).delete();
    return true;
  }

  static Future<void> batchDelete(
    final Object field, {
    final Object? isEqualTo,
  }) async {
    final tempNotesReference =
        notesReference.where(field, isEqualTo: isEqualTo);
    final batch = db.batch();
    await tempNotesReference.get().then(
          (final value) => {
            for (final doc in value.docs) {batch.delete(doc.reference)}
          },
        );
    await batch.commit();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getAll() async {
    return notesReference.get();
  }

  static Future<void> terminateDB() async {
    await db.terminate();
    await db.clearPersistence();
  }
}
