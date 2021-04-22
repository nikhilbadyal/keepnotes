import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:notes/app.dart';
import 'package:notes/util/Languages/Languages.dart';
import 'package:notes/util/LockManager.dart';
import 'package:notes/util/Utilites.dart';
import 'package:shared_preferences/shared_preferences.dart';

late LockChecker lockChecker;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Shared preferences
  //Un secured
  Utilities.prefs = await SharedPreferences.getInstance();
  //secured one
  Utilities.storage = const FlutterSecureStorage();

  lockChecker = LockChecker();
  final locale = await getLocale();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) {
      exit(1);
    }
    if (kDebugMode) {
      timeDilation = 1.0;
    }
  };

  //To make sure that app doesn't rotate when rotation is on in device.
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then(
    (_) => runApp(
      MyNotes(
        locale: locale,
      ),
    ),
  );
}
