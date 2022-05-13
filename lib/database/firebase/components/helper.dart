import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

class FirebaseHelper {
  FirebaseHelper(final String uid) {
    notesReference =
        db.collection(userCollection).doc(uid).collection(notesCollection);
  }

  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static String notesCollection = 'notes';
  static String userCollection = 'user';
  static late CollectionReference<Map<String, dynamic>> notesReference;
  static bool isSuccess = true;

  static Future<bool> insert(final Note note) async {
    try {
      await notesReference.doc(note.id).set(note.toMap());
    } on Exception {
      isSuccess = false;
      logger.wtf('Firebase note insert failed');
    }
    return isSuccess;
  }

  static Future<bool> update(final Note note) async {
    try {
      await notesReference.doc(note.id).update(note.toMap());
    } on Exception {
      isSuccess = false;
      logger.wtf('Firebase note update failed');
    }
    return isSuccess;
  }

  static Future<bool> delete(
    final Note note,
  ) async {
    try {
      await notesReference.doc(note.id).delete();
    } on Exception {
      isSuccess = false;
      logger.wtf('Firebase note delete failed');
    }
    return isSuccess;
  }

  static Future<bool> batchDelete(
    final Object field, {
    final Object? isEqualTo,
  }) async {
    try {
      final tempNotesReference =
          notesReference.where(field, isEqualTo: isEqualTo);
      final batch = db.batch();
      await tempNotesReference.get().then(
            (final value) => {
              for (final doc in value.docs) {batch.delete(doc.reference)}
            },
          );
      await batch.commit();
    } on Exception {
      isSuccess = false;
      logger.wtf('Firebase batch delete failed');
    }
    return isSuccess;
  }

  static Future<bool> batchInsert(final List<dynamic> notesList) async {
    try {
      await db.runTransaction((final transaction) async {
        DocumentReference<Map<String, dynamic>> ref;
        for (final element in notesList) {
          {
            ref = notesReference.doc(element['id'].toString());
            transaction.set(ref, element);
          }
        }
      });
    } on Exception {
      isSuccess = false;
      logger.wtf('Firebase batch insert failed');
    }
    return isSuccess;
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getAll() async {
    return notesReference.get();
  }

  static Future<bool> terminateDB() async {
    try {
      await db.terminate();
      await db.clearPersistence();
    } on Exception {
      isSuccess = false;
      logger.wtf('Firebase terminateDB failed');
    }
    return isSuccess;
  }
}
