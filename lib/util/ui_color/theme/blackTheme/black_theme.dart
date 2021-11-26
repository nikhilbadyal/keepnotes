//25-11-2021 01:02 PM

import 'package:notes/_internal_packages.dart';
import 'package:notes/util/ui_color/theme_data.dart';

ThemeData blackTheme(final Color primary, final Color accent) {
  return ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.black,
    canvasColor: Colors.black,
    appBarTheme: AppBarTheme(color: primary, elevation: 0),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: accent,
    ),
    iconTheme: const IconThemeData().copyWith(color: Colors.white),
    colorScheme: ColorScheme.dark(primary: primary, secondary: accent),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: primary,
      actionTextColor: greyColor,
      contentTextStyle: TextStyle(color: greyColor),
      behavior: SnackBarBehavior.fixed,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.black,
    ),
    cardColor: Colors.black,
    dialogBackgroundColor: Colors.black,
  );
}

/*
appBarTheme: AppBarTheme(
      color: Colors.black,
      elevation: 0,
      actionsIconTheme: const IconThemeData().copyWith(color: Colors.white),
      iconTheme: const IconThemeData().copyWith(color: Colors.white),
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
    ),
    iconTheme: const IconThemeData().copyWith(color: Colors.white),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: primaryColor,
      actionTextColor: greyColor,
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    ),
    colorScheme:
        ColorScheme.dark(primary: primaryColor, secondary: accentColor),
    cardColor: Colors.black,
    primaryColorLight: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    dialogBackgroundColor: Colors.black,
    canvasColor: Colors.black,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: accentColor,
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionHandleColor: primaryColor,
      selectionColor: darken(primaryColor, 50),
    ),
    textTheme: const TextTheme(
      headline5: TextStyle(color: Colors.white),
      headline1: TextStyle(color: Colors.white),
      headline2: TextStyle(color: Colors.white),
      bodyText1: TextStyle(color: Colors.white),
      bodyText2: TextStyle(color: Colors.white),
      caption: TextStyle(color: Colors.white),
      subtitle1: TextStyle(color: Colors.white),
      subtitle2: TextStyle(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(primaryColor),
        foregroundColor: MaterialStateProperty.all(primaryColor),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.black,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        backgroundColor: MaterialStateProperty.all(Colors.black),
      ),
    ),
  );
 */
