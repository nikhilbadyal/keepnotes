import 'dart:math';

import 'package:notes/_external_packages.dart';

import '../util.dart';

int randomNumber({final int upper = 3}) {
  return 1 + Random().nextInt(upper);
}

String randomString({final int? length}) {
  final len = length ?? randomNumber(upper: 400);
  final r = Random();
  final randomString = String.fromCharCodes(
    List.generate(len, (final index) => r.nextInt(33) + 89),
  );
  return randomString;
}

DateTime randomDate() {
  return RandomDate().random();
}

Map<String, dynamic> getNoteJson(final int total) {
  return <String, dynamic>{
    'id': const Uuid().v4(),
    'title': randomString(),
    'content': randomString(),
    'lastModify': randomDate().millisecondsSinceEpoch,
    'state': randomNumber(),
  };
}

List<Map<String, dynamic>> getRandomNotes({final int total = 10}) {
  return List<Map<String, dynamic>>.generate(
    total,
    getNoteJson,
    growable: false,
  );
}
