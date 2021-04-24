import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:notes/app.dart';
import 'package:notes/model/Languages.dart';
import 'package:notes/util/Utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Utilities.prefs = await SharedPreferences.getInstance();
  Utilities.storage = const FlutterSecureStorage();
  final password = await Utilities.storage.read(key: 'password') ?? '';
  final locale = await getLocale();
  FlutterError.onError = (details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) {
      exit(1);
    }
    if (kDebugMode) {
      timeDilation = 1;
    }
  };

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then(
    (_) => runApp(
      MyNotes(
        password,
        locale: locale,
      ),
    ),
  );
}
