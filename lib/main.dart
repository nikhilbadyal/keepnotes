import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:notes/app.dart';
import 'package:notes/util/LockManager.dart';
import 'package:notes/util/Utilites.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Utilities.prefs = await SharedPreferences.getInstance();
  final lockChecker = LockChecker();
  getNotes();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) {
      exit(1);
    }
    if (kDebugMode) {
      timeDilation = 1.0;
    }
  };
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then(
    (_) => runApp(
      MyNotes(lockChecker),
    ),
  );
}

void getNotes() {}
