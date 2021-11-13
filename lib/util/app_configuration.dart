import 'package:notes/_app_packages.dart';
import 'package:notes/_internal_packages.dart';

Color defaultPrimary = Colors.deepOrangeAccent;

class AppConfiguration with ChangeNotifier {
  AppConfiguration() {
    initConfig();
  }

  late Color primaryColor;
  late AppTheme appTheme;
  late IconColorStatus iconColorStatus;
  late Color iconColor;
  late ThemeData currentTheme;
  late bool isHiddenDiscovered;

  Future<void> initConfig() async {
    getPrimaryColor();
    getAppTheme();
    getIconColorStatus();
    getIconColor();
    getDiscoveryStat();
  }

  void changePrimaryColor({bool write = false}) {
    currentTheme = appTheme == AppTheme.light
        ? lightTheme(primaryColor)
        : blackTheme(primaryColor);
    if (write) {
      Utilities.addIntToSF('primaryColor', primaryColor.value);
    } else {
      notifyListeners();
    }
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> setHiddenDiscovered(bool status) async {
    isHiddenDiscovered = status;
    await Utilities.addBoolToSF('hiddenDiscovered', value: status);
  }

  void changeAppTheme({bool write = false}) {
    currentTheme = appTheme == AppTheme.light
        ? lightTheme(primaryColor)
        : blackTheme(primaryColor);
    if (iconColorStatus == IconColorStatus.noColor) {
      iconColor = appTheme == AppTheme.light ? Colors.black : Colors.white;
    }
    if (write) {
      Utilities.addIntToSF('appTheme', appTheme.index);
    }
    notifyListeners();
  }

  void changeLocale(String langCode, {bool write = false}) {
    if (write) {
      Utilities.addStringToSF('appLocale', langCode);
    }
  }

  void changeIconColor() {
    Utilities.addIntToSF('iconColorStatus', 1);
    Utilities.addIntToSF('iconColor', iconColor.value);
  }

  void changeIconColorStatus(int status) {
    Utilities.addIntToSF('iconColorStatus', status);
  }

  void getPrimaryColor() {
    final intVal = Utilities.getIntFromSF('primaryColor');
    if (intVal == null) {
      primaryColor = defaultPrimary;
    } else {
      primaryColor = Color(intVal);
    }
  }

  void getAppTheme() {
    final intVal = Utilities.getIntFromSF('appTheme');
    if (intVal == null) {
      appTheme = AppTheme.light;
    } else {
      appTheme = AppTheme.values[intVal];
    }
    currentTheme = appTheme == AppTheme.light
        ? lightTheme(primaryColor)
        : blackTheme(primaryColor);
  }

  void getIconColorStatus() {
    var intVal = Utilities.getIntFromSF('iconColorStatus');
    if (intVal == null) {
      iconColorStatus = IconColorStatus.uiColor;
    } else {
      try {
        intVal = intVal > 2 ? 2 : intVal;
        iconColorStatus = IconColorStatus.values[intVal];
      } on Exception catch (_) {
        unawaited(Utilities.addIntToSF('iconColorStatus', 2));
        iconColorStatus = IconColorStatus.uiColor;
      }
    }
  }

  void getIconColor() {
    final intVal = Utilities.getIntFromSF('iconColor');
    switch (iconColorStatus) {
      case IconColorStatus.noColor:
        iconColor = appTheme == AppTheme.light ? Colors.black : Colors.white;
        break;
      case IconColorStatus.pickedColor:
        iconColor = Color(intVal!);
        break;
      case IconColorStatus.uiColor:
        iconColor = primaryColor;
        break;
    }
  }

  void getDiscoveryStat() {
    final stat = Utilities.getBoolFromSF('hiddenDiscovered');
    if (stat == null) {
      isHiddenDiscovered = false;
    } else {
      isHiddenDiscovered = stat;
    }
  }
}

List<Color> appColors = <Color>[
  Colors.red,
  Colors.redAccent,
  Colors.pink,
  Colors.pinkAccent,
  Colors.purple,
  Colors.purpleAccent,
  Colors.deepPurple,
  Colors.deepPurpleAccent,
  Colors.indigo,
  Colors.indigoAccent,
  Colors.blue,
  Colors.blueAccent,
  Colors.lightBlue,
  // Colors.lightBlueAccent,
  Colors.cyan,
  // Colors.cyanAccent,
  Colors.teal,
  // Colors.tealAccent,
  Colors.green,
  // Colors.greenAccent,
  Colors.lightGreen,
  // Colors.lightGreenAccent,
  // Colors.lime,
  Colors.orange,
  Colors.deepOrange,
  Colors.deepOrangeAccent,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,

  // const Color(0xFF00E0C7),
  const Color(0xFF006270),
  const Color(0xFFFF7582),
  const Color(0xFF355C7D),
  const Color(0xFFF64668),
  const Color(0xFFfd9400),
  //TODO fix this
  // Colors.black,
];

List<BoxShadow> shadow = [
  BoxShadow(
    color: Colors.grey[200]!,
    blurRadius: 30,
    offset: const Offset(0, 10),
  )
];

enum AppTheme { dark, black, light }
