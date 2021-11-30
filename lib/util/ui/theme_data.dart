import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

// opp - iconThemeData
// same color as app white/black canvas

Color darken(final Color c, [final int percent = 10]) {
  final f = 1 - percent / 100;
  return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
      (c.blue * f).round());
}

Color lighten(final Color c, [final int percent = 10]) {
  final p = percent / 100;
  return Color.fromARGB(
    c.alpha,
    c.red + ((255 - c.red) * p).round(),
    c.green + ((255 - c.green) * p).round(),
    c.blue + ((255 - c.blue) * p).round(),
  );
}

ThemeData getThemeData() {
  final primary = Color(getIntFromSF('primaryColor') ?? defaultPrimary.value);
  final accent = Color(getIntFromSF('accentColor') ?? defaultAccent.value);
  final appTheme = AppTheme.values[getIntFromSF('appTheme') ?? 0];
  switch (appTheme) {
    case AppTheme.dark:
    case AppTheme.black:
      return blackTheme(primary, accent);
    case AppTheme.light:
      return lightTheme(primary, accent);
  }
}

List<Color> primaryColors = [
  const Color(0xff1a73e8),
  const Color(0xffffa842),
  const Color(0xffff4151),
  const Color(0xffb31818),
  const Color(0xff1ed760),
  const Color(0xff5e97f6),
  const Color(0xffff8055),
  const Color(0xff47ae84),
  const Color(0xff4a7ca5),
  const Color(0xffa86bd5),
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.blueGrey,
  Colors.black
];
List<Color> secondaryColors = [
  const Color(0xff0370FF),
  const Color(0xffFFA842),
  const Color(0xffFF4151),
  const Color(0xffC70404),
  const Color(0xff05EF59),
  const Color(0xff5595FF),
  const Color(0xffFF8055),
  const Color(0xff2EC688),
  const Color(0xff327EBD),
  const Color(0xffAB58E8),
  const Color(0xffFF392B),
  const Color(0xffFF085C),
  const Color(0xffAB11C5),
  const Color(0xff6022CF),
  const Color(0xff2740CD),
  const Color(0xff1597FF),
  const Color(0xff00AAF7),
  const Color(0xff00BCD4),
  const Color(0xff009688),
  const Color(0xff33C839),
  const Color(0xff8DDB32),
  const Color(0xffE0F322),
  const Color(0xffFF9800),
  const Color(0xffFF5722),
  const Color(0xff8C4C35),
  const Color(0xff4885A2),
];
