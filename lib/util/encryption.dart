import 'package:encrypt/encrypt.dart';
import 'package:notes/_aap_packages.dart';

class Encrypt {
  Encrypt(final String password) {
    final myKey = password.padLeft(32, '#');
    key = Key.fromUtf8(myKey);
    iv = IV.fromLength(16);
    encrypter = Encrypter(
      AES(key),
    );
  }

  late Key key;
  late IV iv;
  late Encrypter encrypter;

  void encrypt(final Note copiedNote) {
    copiedNote
      ..title = encryptStr(copiedNote.title)
      ..content = encryptStr(copiedNote.content);
  }

  void decrypt(final Note copiedNote) {
    copiedNote
      ..title = decryptStr(copiedNote.title)
      ..content = decryptStr(copiedNote.content);
  }

  String decryptStr(final String str) {
    if (str.isEmpty) {
      return str;
    }
    return encrypter.decrypt64(str, iv: iv);
  }

  String encryptStr(final String str) {
    if (str.isEmpty) {
      return str;
    }
    return encrypter.encrypt(str, iv: iv).base64;
  }
}
