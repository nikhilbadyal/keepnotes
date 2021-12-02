import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

// opp - iconThemeData
// same color as app white/black canvas

Color darken(final Color c, [final int percent = 10]) {
  final f = 1 - percent / 100;
  return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
      (c.blue * f).round(),);
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
  final appTheme =
      AppTheme.values[getIntFromSF('appTheme') ?? AppTheme.black.index];
  switch (appTheme) {
    case AppTheme.dark:
    case AppTheme.black:
      return blackTheme(primary, accent);
    case AppTheme.light:
      return lightTheme(primary, accent);
  }
}
