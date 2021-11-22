//18-11-2021 10:18
import 'package:notes/_app_packages.dart';

Future<void> addStringToSF(final String key, final String value) async =>
    Utilities.prefs.setString(key, value);

Future<void> addBoolToSF(final String key, {required final bool value}) async =>
    Utilities.prefs.setBool(key, value);

Future<void> addIntToSF(final String key, final int value) async =>
    Utilities.prefs.setInt(key, value);

String? getStringFromSF(final String key) {
  try {
    return Utilities.prefs.getString(key);
  } on Error catch (_) {
    return null;
  }
}

bool? getBoolFromSF(final String key) {
  try {
    return Utilities.prefs.getBool(key);
  } on Error catch (_) {
    return null;
  }
}

int? getIntFromSF(final String key) => Utilities.prefs.getInt(key);

Future<void> removeFromSF(final String key) async =>
    Utilities.prefs.remove(key);
