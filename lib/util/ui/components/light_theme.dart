//25-11-2021 01:02 PM

import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

ThemeData lightTheme(final Color primary, final Color secondary) {
  return ThemeData.light().copyWith(
    appBarTheme: AppBarTheme(
      elevation: 0,
      color: primary,
      foregroundColor: primary == Colors.white ? Colors.grey.shade900 : null,
      /*systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: primary == Colors.white ? primary : null,
          statusBarIconBrightness:
              primary == Colors.white ? Brightness.dark : Brightness.light,
        ),*/
    ),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(foregroundColor: Colors.white),
    colorScheme: ColorScheme.light(
      primary: primary,
      secondary: secondary,
    ),
    iconTheme: const IconThemeData().copyWith(color: Colors.black),
    canvasColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: secondary,
      actionTextColor: greyColor,
      contentTextStyle: TextStyle(color: greyColor),
      behavior: SnackBarBehavior.fixed,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.black,
    ),
    cardColor: Colors.black,
    dialogBackgroundColor: Colors.black,
    dividerColor: Colors.white,
    dialogTheme: DialogTheme(
      backgroundColor: Colors.white,
      titleTextStyle: const TextStyle().copyWith(color: Colors.black),
    ),
  );
}
