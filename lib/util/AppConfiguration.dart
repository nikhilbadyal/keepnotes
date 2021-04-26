import 'package:flutter/material.dart';
import 'package:notes/util/ThemeData.dart';
import 'package:notes/util/Utilities.dart';
import 'package:pedantic/pedantic.dart';

Color defaultPrimary = const Color(0xFF355C7D);

Color greyColor = const Color(0xFFEAEAEA);

class AppConfiguration with ChangeNotifier {
  AppConfiguration() {
    initConfig();
  }

  late Color primaryColor;
  late AppTheme appTheme;
  late IconColorStatus iconColorStatus;
  late Color iconColor;
  late ThemeData currentTheme;

  Future<void> initConfig() async {
    var intVal = Utilities.getIntFromSF('primaryColor');
    if (intVal == null) {
      primaryColor = defaultPrimary;
    } else {
      primaryColor = Color(intVal);
    }

    intVal = null;
    intVal = Utilities.getIntFromSF('appTheme');
    if (intVal == null) {
      appTheme = AppTheme.Light;
    } else {
      appTheme = AppTheme.values[intVal];
    }
    currentTheme = appTheme == AppTheme.Light
        ? lightTheme(primaryColor)
        : blackTheme(primaryColor);

    intVal = null;
    intVal = Utilities.getIntFromSF('iconColorStatus');
    if (intVal == null) {
      iconColorStatus = IconColorStatus.NoColor;
    } else {
      try {
        intVal = intVal > 2 ? 2 : intVal;
        iconColorStatus = IconColorStatus.values[intVal];
      } on Exception catch (_) {
        unawaited(Utilities.addIntToSF('iconColorStatus', 2));
        iconColorStatus = IconColorStatus.UiColor;
      }
    }
    intVal = null;
    intVal = Utilities.getIntFromSF('iconColor');
    switch (iconColorStatus) {
      case IconColorStatus.NoColor:
        iconColor = appTheme == AppTheme.Light ? Colors.black : Colors.white;
        break;
      case IconColorStatus.PickedColor:
        iconColor = Color(intVal!);
        break;
      case IconColorStatus.UiColor:
        iconColor = primaryColor;
        break;
    }
  }

  void changePrimaryColor({bool write = false}) {
    currentTheme = appTheme == AppTheme.Light
        ? lightTheme(primaryColor)
        : blackTheme(primaryColor);
    if (write) {
      Utilities.addIntToSF('primaryColor', primaryColor.value);
    } else {
      notifyListeners();
    }
  }

  void changeAppTheme({bool write = false}) {
    currentTheme = appTheme == AppTheme.Light
        ? lightTheme(primaryColor)
        : blackTheme(primaryColor);
    if (iconColorStatus == IconColorStatus.NoColor) {
      iconColor = appTheme == AppTheme.Light ? Colors.black : Colors.white;
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
  Colors.lightBlueAccent,
  Colors.cyan,
  Colors.cyanAccent,
  Colors.teal,
  Colors.tealAccent,
  Colors.green,
  Colors.greenAccent,
  Colors.lightGreen,
  Colors.lightGreenAccent,
  Colors.lime,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,

  const Color(0xFF00E0C7),
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

Color darken(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100, 'Percent must be b/w 1&100');
  final f = 1 - percent / 100;
  return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
      (c.blue * f).round());
}

Color lighten(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100, 'Percent must be b/w 1&100');
  final p = percent / 100;
  return Color.fromARGB(
    c.alpha,
    c.red + ((255 - c.red) * p).round(),
    c.green + ((255 - c.green) * p).round(),
    c.blue + ((255 - c.blue) * p).round(),
  );
}

enum AppTheme { Dark, Black, Light }
