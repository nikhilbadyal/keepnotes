import 'package:notes/_app_packages.dart';
import 'package:notes/_internal_packages.dart';

class LockChecker with ChangeNotifier {
  LockChecker() {
    intiConfig();
  }

  void intiConfig() {
    localAuthentication.canCheckBiometrics.then((final value) {
      bioNotAvailable = !value;
    });
  }

  // TODO Check whether i can remove this password field or not
  late String password;
  late bool bioNotAvailable;

  Future<void> resetConfig({required final bool shouldResetBio}) async {
    password = '';
    if (shouldResetBio) {
      await resetBio();
    }
    unawaited(removeFromSF('password'));
  }

  Future<void> resetBio() async {
    await removeFromSF('bio');
    await removeFromSF('firstTimeNeeded');
    await removeFromSF('hiddenDiscovered');
    await removeFromSF('fpDirectly');
    await removeFromSF('gender');
  }

  Future<void> passwordSetConfig(final String enteredPassword) async {
    password = enteredPassword;
    await addStringToSF('password', encryption.encryptStr(password));
  }

  Future<void> bioEnabledConfig() async {
    await addBoolToSF('bio', value: true);
    await addBoolToSF('firstTimeNeeded', value: true);
  }

  Future<bool> authenticate(final BuildContext context) async {
    var isAuthenticated = false;
    await localAuthentication.getAvailableBiometrics();
    try {
      isAuthenticated = await localAuthentication.authenticate(
        localizedReason: Language.of(context).localizedReason,
        stickyAuth: true,
        biometricOnly: true,
      );
    } on PlatformException catch (errorCode) {
      isAuthenticated = false;
      await _handleError(errorCode: errorCode.code, context: context);
    }
    return isAuthenticated;
  }

  Future<void> _handleError(
          {required final String errorCode,
          required final BuildContext context}) async =>
      showDialog<void>(
        barrierDismissible: true,
        context: context,
        builder: (final context) => MyAlertDialog(
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
}
