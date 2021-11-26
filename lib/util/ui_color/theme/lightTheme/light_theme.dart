//25-11-2021 01:02 PM

import 'package:notes/_app_packages.dart';
import 'package:notes/_internal_packages.dart';

ThemeData lightTheme(final Color primary, final Color secondary) {
  return ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(elevation: 0),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(foregroundColor: Colors.white),
    colorScheme: ColorScheme.light(primary: primary, secondary: secondary),
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

/*
appBarTheme: AppBarTheme(
        elevation: 0,
        actionsIconTheme: const IconThemeData().copyWith(color: Colors.black),
        iconTheme: const IconThemeData().copyWith(color: Colors.black),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 22),
      ),
      colorScheme: ColorScheme.light(primary: primary, secondary: secondary),
      iconTheme: const IconThemeData().copyWith(color: Colors.black),
      dialogTheme: const DialogTheme(
          titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
      )),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primary,
        actionTextColor: Colors.white,
        contentTextStyle: const TextStyle(
          color: Colors.white,
        ),
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      textTheme: TextTheme(
        headline5: const TextStyle(color: Colors.black),
        headline1: const TextStyle(color: Colors.black),
        headline2: const TextStyle(color: Colors.black),
        bodyText1: const TextStyle(color: Colors.black),
        bodyText2: const TextStyle(color: Colors.black),
        caption: const TextStyle(color: Colors.black),
        subtitle1: const TextStyle(color: Colors.black),
        subtitle2: TextStyle(color: Colors.grey[200]),
      ),
      textSelectionTheme: TextSelectionThemeData(
        // cursorColor: primary,
        // selectionHandleColor: primary,
        selectionColor: lighten(primary, 65),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(primary),
          foregroundColor: MaterialStateProperty.all(primary),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: secondary,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(primary),
        ),
      ),
 */
