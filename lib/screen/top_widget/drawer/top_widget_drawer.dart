//25-11-2021 04:06 PM

import 'package:notes/_app_packages.dart';
import 'package:notes/_internal_packages.dart';

Widget? getDrawer(final ScreenTypes topScreen, final BuildContext context) {
  switch (topScreen) {
    case ScreenTypes.welcome:
    case ScreenTypes.login:
    case ScreenTypes.forgotPassword:
    case ScreenTypes.signup:
    case ScreenTypes.lock:
    case ScreenTypes.setpass:
      return null;
    default:
      return const MyDrawer();
  }
}
