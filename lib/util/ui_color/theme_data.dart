import 'package:notes/_internal_packages.dart';

// opp - iconThemeData
// same canvas
ThemeData darkTheme = ThemeData();

Color greyColor = const Color(0xFFEAEAEA);

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

ThemeData blackTheme(final Color primaryColor, final Color accentColor) {
  return ThemeData.dark().copyWith(
    appBarTheme: AppBarTheme(
      color: primaryColor,
      elevation: 0,
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
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (final states) {
            if (states.contains(MaterialState.disabled)) {
              return greyColor;
            }
            return primaryColor;
          },
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (final states) {
            if (states.contains(MaterialState.disabled)) {
              return greyColor;
            }
            return primaryColor;
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
          (final states) {
            if (states.contains(MaterialState.disabled)) {
              return greyColor;
            }
            return Colors.white;
          },
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (final states) {
            if (states.contains(MaterialState.disabled)) {
              return greyColor;
            }
            return Colors.black;
          },
        ),
      ),
    ),
  );
}

ThemeData lightTheme(final Color primaryColor, final Color accentColor) =>
    ThemeData.light().copyWith(
      appBarTheme: AppBarTheme(
        color: primaryColor,
        elevation: 0,
        actionsIconTheme: const IconThemeData().copyWith(color: Colors.white),
        iconTheme: const IconThemeData().copyWith(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
      ),
      colorScheme:
          ColorScheme.dark(primary: primaryColor, secondary: accentColor),
      iconTheme: const IconThemeData().copyWith(color: Colors.black),
      canvasColor: Colors.white,
      cardColor: const Color.fromARGB(255, 255, 255, 255),
      toggleableActiveColor: primaryColor,
      primaryColor: primaryColor,
      dialogTheme: const DialogTheme(
          titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
      )),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primaryColor,
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
        cursorColor: primaryColor,
        selectionHandleColor: primaryColor,
        selectionColor: lighten(primaryColor, 65),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (final states) {
              if (states.contains(MaterialState.disabled)) {
                return greyColor;
              }
              return primaryColor;
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (final states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.black;
              }
              return primaryColor;
            },
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: accentColor,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (final states) {
              if (states.contains(MaterialState.disabled)) {
                return greyColor;
              }
              return primaryColor;
            },
          ),
        ),
      ),
    );
