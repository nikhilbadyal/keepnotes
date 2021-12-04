//25-11-2021 01:02 PM

import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

ThemeData lightTheme(final Color primary, final Color secondary) {
  return ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    canvasColor: Colors.white,
    iconTheme: const IconThemeData().copyWith(color: Colors.white),
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
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      elevation: 0,
    ),
    colorScheme: ColorScheme.light(primary: primary, secondary: secondary),
  );
}
