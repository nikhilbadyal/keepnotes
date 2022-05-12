//25-11-2021 03:54 PM

import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

AppBar? getAppBar(final ScreenTypes topScreen, final BuildContext context) {
  switch (topScreen) {
    case ScreenTypes.hidden:
      return AppBar(
        title: Text(context.language.hidden),
      );
    case ScreenTypes.home:
      return AppBar(
        title: Text(context.language.home),
      );

    case ScreenTypes.archive:
      return AppBar(
        title: Text(context.language.archive),
      );

    case ScreenTypes.backup:
      return AppBar(
        title: Text(context.language.backup),
      );

    case ScreenTypes.trash:
      return AppBar(
        title: Text(context.language.trash),
      );

    case ScreenTypes.aboutMe:
      return AppBar(
        title: Text(context.language.about),
      );
    case ScreenTypes.settings:
      return AppBar(
        title: Text(context.language.settings),
      );
    case ScreenTypes.intro:
    case ScreenTypes.signup:
    case ScreenTypes.login:
    case ScreenTypes.forgotPassword:
      return AppBar(
        actionsIconTheme: const IconThemeData().copyWith(
          color: (getIntFromSF('appTheme') ?? 0) == AppTheme.light.index
              ? Colors.black
              : Colors.white,
        ),
        iconTheme: const IconThemeData().copyWith(
          color: (getIntFromSF('appTheme') ?? 0) == AppTheme.light.index
              ? Colors.black
              : Colors.white,
        ),
        elevation: 0,
        backgroundColor: context.theme.canvasColor,
      );
    default:
      return null;
  }
}
