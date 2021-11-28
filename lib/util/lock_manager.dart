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

  Future<void> resetConfig() async {
    password = '';
    await resetBio();
    await removeFromSF('password');
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

  Future<bool> authenticate(final String reason) async {
    await localAuthentication.getAvailableBiometrics();
    try {
      return localAuthentication.authenticate(
        localizedReason: reason,
        stickyAuth: true,
        biometricOnly: true,
      );
    } catch (errorCode) {
      return false;
    }
  }

// TODO handle auth error
/*Future<void> _handleError(
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
      );*/
}
