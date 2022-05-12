//25-11-2021 04:06 PM

import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

Widget? getDrawer(final ScreenTypes topScreen, final BuildContext context) {
  switch (topScreen) {
    case ScreenTypes.intro:
    case ScreenTypes.login:
    case ScreenTypes.forgotPassword:
    case ScreenTypes.signup:
    case ScreenTypes.enterPin:
    case ScreenTypes.setpass:
      return null;
    default:
      return const MyDrawer();
  }
}
