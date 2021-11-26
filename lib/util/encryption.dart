import 'package:encrypt/encrypt.dart';
import 'package:notes/_app_packages.dart';

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
    if (copiedNote.title.isNotEmpty) {
      copiedNote.title = encrypter.encrypt(copiedNote.title, iv: iv).base64;
    }
    if (copiedNote.content.isNotEmpty) {
      copiedNote.content = encrypter.encrypt(copiedNote.content, iv: iv).base64;
    }
  }

  void decrypt(final Note copiedNote) {
    if (copiedNote.title.isNotEmpty) {
      copiedNote.title = encrypter.decrypt64(copiedNote.title, iv: iv);
    }
    if (copiedNote.content.isNotEmpty) {
      copiedNote.content = encrypter.decrypt64(copiedNote.content, iv: iv);
    }
  }

  String decryptStr(final String str) {
    if (str.isEmpty) {
      return str;
    }
    return encrypter.decrypt64(str, iv: iv);
  }

  void recrpyt(final String data, final String oldPass, final String newPass) {
    decryptStr(data);
    encryptStr(data);
  }

  String encryptStr(final String str) {
    if (str.isEmpty) {
      return str;
    }
    return encrypter.encrypt(str, iv: iv).base64;
  }
}
