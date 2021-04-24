import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notes/model/Languages.dart';
import 'package:notes/util/Utilities.dart';
import 'package:notes/widget/AlertDialog.dart';
import 'package:pedantic/pedantic.dart';
import 'package:provider/provider.dart';

class LockChecker with ChangeNotifier {
  LockChecker(this.password) {
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
  late bool usedOlderVersion;
  MethodChannel channel = const MethodChannel('externalStorage');
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  late bool directlyDelete;

  void updateDetails() {}

  Future<void> updateGender(String gender) async =>
      Utilities.addStringToSF('gender', gender);

  void initConfig() {
    unawaited(Utilities.removeValueFromSF('password'));
    bioEnabled = Utilities.getBoolFromSF('bio') ?? false;
    firstTimeNeeded = Utilities.getBoolFromSF('firstTimeNeeded') ?? false;
    bioAvailable = bioEnabled;
    fpDirectly = Utilities.getBoolFromSF('fpDirectly') ?? false;
    directlyDelete = Utilities.getBoolFromSF('directlyDelete') ?? true;
    gender = Utilities.getStringFromSF('gender') ?? 'women';
    usedOlderVersion = Utilities.getBoolFromSF('usedOlderVersion') ?? true;
    passwordSet = password.isNotEmpty;
    unawaited(getPath());
  }

  Future<void> getPath() async {
    exportPath = await channel.invokeMethod('getExternalStorageDirectory');
    if (!bioAvailable) {
      bioAvailable = await _localAuthentication.canCheckBiometrics;
    }
  }

  Future<void> resetConfig() async {
    password = '';
    passwordSet = false;
    bioEnabled = false;
    firstTimeNeeded = false;
    unawaited(Utilities.storage.delete(key: 'password'));
    await Utilities.removeValueFromSF('bio');
    await Utilities.removeValueFromSF('biofirstTimeNeeded');
  }

  Future<void> changePassword(String newPassword) async {
    password = newPassword;
    firstTimeNeeded = true;
    unawaited(Utilities.storage.delete(key: 'password'));
    await Utilities.removeValueFromSF('bio');
    await Utilities.addBoolToSF('biofirstTimeNeeded', value: true);
  }

  Future<void> passwordSetConfig(String enteredPassword) async {
    password = enteredPassword;
    passwordSet = true;
    unawaited(Utilities.storage.write(key: 'password', value: enteredPassword));
  }

  Future<void> bioEnabledConfig() async {
    bioEnabled = true;
    bioAvailable = true;
    firstTimeNeeded = true;
    await Utilities.addBoolToSF('bio', value: true);
    await Utilities.addBoolToSF('firstTimeNeeded', value: true);
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
      await Provider.of<LockChecker>(context, listen: false).bioEnabledConfig();
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
      barrierDismissible: false,
      builder: (context) => MyAlertDialog(
        title: Text(Language.of(context).error),
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
            child: Text(Language.of(context).alertDialogOp2),
          ),
        ],
      ),
    );
  }

  Future<void> setUsedOlderVersion() async {
    await Utilities.addBoolToSF('usedOlderVersion', value: usedOlderVersion);
  }
}
