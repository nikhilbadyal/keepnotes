import 'package:flutter/material.dart';
import 'package:notes/util/AppConfiguration.dart';

ThemeData darkTheme = ThemeData();

ThemeData blackTheme(BuildContext context) {
  return ThemeData.dark().copyWith(
    snackBarTheme: SnackBarThemeData(
      backgroundColor: selectedPrimaryColor,
      actionTextColor: greyColor,
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    ),
    accentColor: selectedPrimaryColor,
    cardColor: Colors.black,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    primaryColorLight: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    dialogBackgroundColor: Colors.black,
    canvasColor: Colors.black,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: selectedPrimaryColor,
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: selectedPrimaryColor,
      selectionHandleColor: selectedPrimaryColor,
      selectionColor: darken(selectedPrimaryColor, 50),
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
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return greyColor;
            }
            return selectedPrimaryColor; // Defer to the widget's default.
          },
        ),
        /* elevation: MaterialStateProperty.resolveWith<double>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return 0;
            }
            return 0; // Defer to the widget's default.
          },
        ),*/
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return greyColor;
            }
            return selectedPrimaryColor; // Defer to the widget's default.
          },
        ),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.black,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return greyColor;
            }
            return Colors.white; // Defer to the widget's default.
          },
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return greyColor;
            }
            return Colors.black; // Defer to the widget's default.
          },
        ),
      ),
    ),
  );
}

ThemeData lightTheme(BuildContext context) {
  // debugPrint(selectedPrimaryColor.toString());
  return ThemeData.light().copyWith(
    canvasColor: Colors.white,
    cardColor: const Color.fromARGB(255, 255, 255, 255),
    accentColor: selectedPrimaryColor,
    toggleableActiveColor: selectedPrimaryColor,
    primaryColor: selectedPrimaryColor,
    dialogTheme: const DialogTheme(
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: selectedPrimaryColor,
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
    brightness: Brightness.light,
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
      cursorColor: selectedPrimaryColor,
      selectionHandleColor: selectedPrimaryColor,
      selectionColor: lighten(selectedPrimaryColor, 65),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(10));
            }
            return ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(10));
          },
        ),
        minimumSize: MaterialStateProperty.resolveWith<Size>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return const Size(30, 40);
            }
            return const Size(30, 40);
          },
        ),

        /* padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return EdgeInsets.zero;
            }
            return EdgeInsets.zero;
          },
        ),*/
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return greyColor;
            }
            return selectedPrimaryColor;
          },
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.black;
            }
            return selectedPrimaryColor;
          },
        ),
      ),
    ),
    floatingActionButtonTheme:
        Theme.of(context).floatingActionButtonTheme.copyWith(
              backgroundColor: selectedPrimaryColor,
              foregroundColor: Colors.white,
            ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return greyColor;
            }
            return selectedPrimaryColor;
          },
        ),
      ),
    ),
  );
}
