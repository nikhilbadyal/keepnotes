import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

class AppConfiguration with ChangeNotifier {
  AppConfiguration() {
    intiConfig();
  }

  late String password;
  late bool bioNotAvailable;

  void intiConfig() {
    localAuthentication.canCheckBiometrics.then((final value) {
      bioNotAvailable = !value;
    });
  }

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
    await addStringToSF('password', encryption.encryptStr(password),);
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

  void changePrimaryColor(final Color primaryColor) {
    addIntToSF('primaryColor', primaryColor.value);
    notifyListeners();
  }

  void changeAccentColor(final Color accentColor) {
    addIntToSF('accentColor', accentColor.value);
    notifyListeners();
  }

  void changeAppTheme(final AppTheme appTheme) {
    addIntToSF('appTheme', appTheme.index);
    notifyListeners();
  }

  Future<void> setHiddenDiscovered() async {
    await addBoolToSF('hiddenDiscovered', value: true);
  }

  void changeLocale(
    final String langCode,
  ) {
    addStringToSF('appLocale', langCode);
  }
}
