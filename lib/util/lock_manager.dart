import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class LockChecker with ChangeNotifier {
  LockChecker() {
    initConfig();
  }

  final int passwordLength = 4;
  late String password;
  late bool bioEnabled;
  late bool bioAvailable;
  late bool firstTimeNeeded;

  late bool fpDirectly;
  late String exportPath;
  late String gender;
  late bool usedOlderVersion;
  late bool directlyDelete;
  MethodChannel channel = const MethodChannel('externalStorage');
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<void> updateGender(String gender) async =>
      Utilities.addStringToSF('gender', gender);

  void addGenderToSf() {
    Utilities.addStringToSF('gender', gender);
  }

  void initConfig() {
    unawaited(Utilities.removeValueFromSF('password'));
    bioEnabled = Utilities.getBoolFromSF('bio') ?? false;
    firstTimeNeeded = Utilities.getBoolFromSF('firstTimeNeeded') ?? false;
    // bioAvailable = false;
    //TODO fix this
    bioAvailable = bioEnabled;
    fpDirectly = Utilities.getBoolFromSF('fpDirectly') ?? false;
    directlyDelete = Utilities.getBoolFromSF('directlyDelete') ?? true;
    gender = Utilities.getStringFromSF('gender') ?? 'women';
    usedOlderVersion = Utilities.getBoolFromSF('usedOlderVersion') ?? true;
    unawaited(getPath());
  }

  Future<void> getPath() async {
    exportPath = await channel.invokeMethod('getExternalStorageDirectory');
    if (!bioAvailable) {
      // bioAvailable = false;
      bioAvailable = await _localAuthentication.canCheckBiometrics;
    }
  }

  Future<void> resetConfig({required bool shouldResetBio}) async {
    password = '';
    if (shouldResetBio) {
      await resetBio();
    }
    unawaited(Utilities.storage.delete(key: 'password'));
  }

  Future<void> resetBio() async {
    if (bioEnabled) {
      bioEnabled = false;
      firstTimeNeeded = false;
      await Utilities.removeValueFromSF('bio');
      await Utilities.removeValueFromSF('biofirstTimeNeeded');
    }
  }

  Future<void> passwordSetConfig(String enteredPassword) async {
    password = enteredPassword;
    await Utilities.storage.write(key: 'password', value: enteredPassword);
  }

  Future<void> bioEnabledConfig() async {
    bioEnabled = true;
    bioAvailable = true;
    firstTimeNeeded = true;
    await Utilities.addBoolToSF('bio', value: true);
    await Utilities.addBoolToSF('firstTimeNeeded', value: true);
  }

  Future<bool> authenticateUser(BuildContext context) async {
    var isAuthenticated = false;
    await _localAuthentication.getAvailableBiometrics();
    try {
      isAuthenticated = await _localAuthentication.authenticate(
        localizedReason: 'Authenticate to see the hidden world',
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
    } on PlatformException catch (e) {
      await _handleError(errorCode: e.code, context: context);
      isAuthenticated = false;
    }
    return isAuthenticated;
  }

  Future<void> _handleError(
          {required String errorCode, required BuildContext context}) async =>
      showDialog<void>(
        barrierDismissible: true,
        context: context,
        builder: (context) => MyAlertDialog(
          title: Text(Language.of(context).error),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(errorCode),
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

  Future<void> setUsedOlderVersion() async {
    await Utilities.addBoolToSF('usedOlderVersion', value: usedOlderVersion);
  }
}
