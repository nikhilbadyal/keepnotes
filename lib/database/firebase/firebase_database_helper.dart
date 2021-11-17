import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/_app_packages.dart';
import 'package:notes/_internal_packages.dart';

class FirebaseDatabaseHelper {
  FirebaseDatabaseHelper(String uid) {
    notesReference =
        db.collection(userCollection).doc(uid).collection(notesCollection);
  }

  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static String notesCollection = 'notes';
  static String userCollection = 'user';
  static late CollectionReference<Map<String, dynamic>> notesReference;

  static Future<bool> insert(Note note) async {
    try {
      await notesReference.doc(note.id).set(note.toMap());
      return true;
    } on Exception catch (e, s) {
      logger.e('Unable to save note to firebase $e $s');
    }
    return false;
  }

  static Future<bool> update(Note note) async {
    try {
      await notesReference.doc(note.id).update(note.toMap());
      return true;
    } on Exception catch (_, __) {
      return false;
    }
  }

  static Future<bool> delete(NoteOperation notesOperation, Note note) async {
    try {
      await notesReference.doc(note.id).delete();
      return true;
    } on Exception catch (_, __) {
      return false;
    }
  }

  static Query<Map<String, dynamic>> queryData(
    Object field, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    List<Object?>? arrayContainsAny,
    List<Object?>? whereIn,
    List<Object?>? whereNotIn,
    bool? isNull,
  }) {
    return db.collection(userCollection).where(field, isEqualTo: isEqualTo);
  }

  static Future<bool> batchInsert(List<Note> jsonList) async {
    await db.runTransaction((transaction) async {
      DocumentReference<Map<String, dynamic>> ref;
      for (final element in jsonList) {
        {
          ref = notesReference.doc(element.id);
          transaction.set(ref, element.toMap());
        }
      }
    });
    return true;
  }

  static Future<bool> batchDelete(
    Object field, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    List<Object?>? arrayContainsAny,
    List<Object?>? whereIn,
    List<Object?>? whereNotIn,
    bool? isNull,
  }) async {
    final tempNotesReference =
        notesReference.where(field, isEqualTo: isEqualTo);
    final batch = db.batch();
    try {
      await tempNotesReference.get().then((value) => {
            value.docs.forEach((element) => {
                  batch.delete(element.reference),
                }),
          });
      await batch.commit();
      return true;
    } on Exception catch (e, s) {
      logger.wtf('Failed to restore from backup$e$s');
    }
    return false;
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getAll() async {
    return notesReference.get();
  }
}
