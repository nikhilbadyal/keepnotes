//25-11-2021 01:02 PM

import 'package:notes/_app_packages.dart';
import 'package:notes/_internal_packages.dart';

ThemeData lightTheme(final Color primary, final Color secondary) {
  return ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(elevation: 0),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(foregroundColor: Colors.white),
    colorScheme: ColorScheme.light(primary: primary, secondary: secondary),
    iconTheme: const IconThemeData().copyWith(color: Colors.black),
    canvasColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: primary,
      actionTextColor: greyColor,
      contentTextStyle: TextStyle(color: greyColor),
      behavior: SnackBarBehavior.fixed,
    ),
  );
}
