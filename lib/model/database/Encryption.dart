import 'package:encrypt/encrypt.dart';
import 'package:notes/app.dart';
import 'package:notes/model/note.dart';

class Encrypt {
  Encrypt() {
    final myKey = myNotes.lockChecker.password.padLeft(32, '#');
    key = Key.fromUtf8(myKey);
    iv = IV.fromLength(16);
    encrypter = Encrypter(AES(key));
  }

  late Key key;

  late IV iv;

  late Encrypter encrypter;

  void encrypt(Note copiedNote) {
    if (copiedNote.title.isNotEmpty) {
      copiedNote.title = encrypter.encrypt(copiedNote.title, iv: iv).base64;
    }
    if (copiedNote.content.isNotEmpty) {
      copiedNote.content = encrypter.encrypt(copiedNote.content, iv: iv).base64;
    }
  }

  void decrypt(Note copiedNote) {
    if (copiedNote.title.isNotEmpty) {
      copiedNote.title = encrypter.decrypt64(copiedNote.title, iv: iv);
    }
    if (copiedNote.content.isNotEmpty) {
      copiedNote.content = encrypter.decrypt64(copiedNote.content, iv: iv);
    }
  }
}
