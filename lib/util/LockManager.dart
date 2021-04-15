import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notes/app.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/util/Utilites.dart';
import 'package:pedantic/pedantic.dart';

class LockChecker {
  LockChecker() {
    initConfig();
  }

  final int passwordLength = 4;
  late String password;
  late bool passwordSet;
  late bool bioEnabled;
  late bool bioAvailable;
  late bool firstTimeNeeded;
  late bool fpDirectly;
  late String exportPath;
  late String gender;
  MethodChannel channel = const MethodChannel('externalStorage');
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  void updateDetails() {}

  Future<void> updateGender(String gender) async {
    return Utilities.addStringToSF('gender', gender);
  }

  Future<void> initConfig() async {
    password = Utilities.getStringValuesSF('password') ?? '';
    passwordSet = password.isNotEmpty;
    bioEnabled = Utilities.getBoolValuesSF('bio') ?? false;
    firstTimeNeeded = Utilities.getBoolValuesSF('firstTimeNeeded') ?? false;
    bioAvailable = bioEnabled || await bioAvailCheck();
    fpDirectly = Utilities.getBoolValuesSF('fpDirectly') ?? false;
    gender = Utilities.getStringValuesSF('gender') ?? 'women';
    unawaited(getPath());
  }

  Future<void> getPath() async {
    final str = DateFormat('yyyyMMdd_HHmmss').format(
      DateTime.now(),
    );
    final file = 'notesExport_$str.json';
    // ignore: prefer_interpolation_to_compose_strings
    exportPath = await channel.invokeMethod('getExternalStorageDirectory') +
        '/NotesApp/$file';
  }

  Future<void> resetConfig() async {
    password = '';
    passwordSet = false;
    bioEnabled = false;
    firstTimeNeeded = false;
    await Utilities.removeValues('password');
    await Utilities.removeValues('bio');
    await Utilities.removeValues('biofirstTimeNeeded');
  }

  Future<void> passwordSetConfig(String enteredPassword) async {
    password = enteredPassword;
    passwordSet = true;
    await Utilities.addStringToSF('password', enteredPassword);
  }

  Future<void> bioEnabledConfig() async {
    bioEnabled = true;
    bioAvailable = true;
    firstTimeNeeded = true;
    await Utilities.addBoolToSF('bio', value: true);
    await Utilities.addBoolToSF('firstTimeNeeded', value: true);
  }

  Future<bool> isBioAvailable() async {
    var isAvailable = false;
    try {
      isAvailable = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (_) {}
    return isAvailable;
  }

  Future<bool> bioAvailCheck() async {
    return isBioAvailable();
  }

  void addGenderToSf() {
    Utilities.addStringToSF('gender', gender);
  }

  Future<bool> authenticateUser(BuildContext context) async {
    var isAuthenticated = false;
    await _localAuthentication.getAvailableBiometrics();
    try {
      isAuthenticated = await _localAuthentication.authenticate(
        localizedReason: 'Please authenticate',
        useErrorDialogs: false,
        stickyAuth: true,
        biometricOnly: true,
      );
    } on PlatformException catch (errorCode) {
      isAuthenticated = false;
      await _handleError(errorCode: errorCode.code, context: context);
    }
    return isAuthenticated;
  }

  Future<bool> authenticateFirstTimeUser(BuildContext context) async {
    var isAuthenticated = false;
    await _localAuthentication.getAvailableBiometrics();
    try {
      isAuthenticated = await _localAuthentication.authenticate(
        localizedReason: 'Please authenticate',
        useErrorDialogs: false,
        stickyAuth: true,
        biometricOnly: true,
      );
    } on PlatformException catch (errorCode) {
      isAuthenticated = false;
      await _handleError(errorCode: errorCode.code, context: context);
    }
    if (isAuthenticated) {
      await myNotes.lockChecker.bioEnabledConfig();
    }
    return isAuthenticated;
  }

  Future<void> _handleError(
      {required String errorCode, required BuildContext context}) async {
    String error;
    if (errorCode == ' PasscodeNotSet') {
      error = 'Please first set passcode in your system settings';
    } else if (errorCode == 'LockedOut') {
      error = 'Too many attempts. Try after 30 seconds';
    } else if (errorCode == 'PermanentlyLockedOut') {
      error = 'Too many attempts. Please open your device with pass first';
    } else if (errorCode == 'NotAvailable') {
      error = 'Setup biometric from setting first';
    } else {
      error = 'Some issue occurred. Please report with code $errorCode';
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return MyAlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Text('Ok :('),
            ),
          ],
        );
      },
    );
  }
}
