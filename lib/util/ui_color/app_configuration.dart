import 'package:notes/_app_packages.dart';
import 'package:notes/_internal_packages.dart';

Color defaultPrimary = Colors.green;
// Color defaultPrimary = Colors.deepOrangeAccent;

class AppConfiguration with ChangeNotifier {
  AppConfiguration() {
    initConfig();
  }

  late Color primaryColor;
  late Color accentColor;
  late AppTheme appTheme;
  late ThemeData currentTheme;
  late bool isHiddenDiscovered;

  Future<void> initConfig() async {
    readFromSf();
  }

  void readFromSf() {
    primaryColor =
        Color(Utilities.getIntFromSF('primaryColor') ?? defaultPrimary.value);
    accentColor =
        Color(Utilities.getIntFromSF('accentColor') ?? defaultPrimary.value);
    appTheme = AppTheme.values[Utilities.getIntFromSF('appTheme') ?? 0];
    currentTheme = appTheme == AppTheme.light
        ? lightTheme(primaryColor, accentColor)
        : blackTheme(primaryColor, accentColor);
    isHiddenDiscovered = Utilities.getBoolFromSF('hiddenDiscovered') ?? false;
  }

  void changePrimaryColor({bool write = false}) {
    currentTheme = appTheme == AppTheme.light
        ? lightTheme(primaryColor, accentColor)
        : blackTheme(primaryColor, accentColor);
    if (write) {
      Utilities.addIntToSF('primaryColor', primaryColor.value);
    }
    notifyListeners();
  }

  void changeAccentColor({bool write = false}) {
    currentTheme = appTheme == AppTheme.light
        ? lightTheme(primaryColor, accentColor)
        : blackTheme(primaryColor, accentColor);
    if (write) {
      Utilities.addIntToSF('accentColor', accentColor.value);
    }
    notifyListeners();
  }

  void changeAppTheme({bool write = false}) {
    currentTheme = appTheme == AppTheme.light
        ? lightTheme(primaryColor, accentColor)
        : blackTheme(primaryColor, accentColor);

    if (write) {
      Utilities.addIntToSF('appTheme', appTheme.index);
    }
    notifyListeners();
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> setHiddenDiscovered(bool status) async {
    isHiddenDiscovered = status;
    await Utilities.addBoolToSF('hiddenDiscovered', value: status);
  }

  void changeLocale(String langCode, {bool write = false}) {
    if (write) {
      Utilities.addStringToSF('appLocale', langCode);
    }
  }

  void changeIconColorStatus(int status) {
    Utilities.addIntToSF('iconColorStatus', status);
  }
}

List<BoxShadow> shadow = [
  BoxShadow(
    color: Colors.grey[200]!,
    blurRadius: 30,
    offset: const Offset(0, 10),
  )
];

enum AppTheme { dark, black, light }
