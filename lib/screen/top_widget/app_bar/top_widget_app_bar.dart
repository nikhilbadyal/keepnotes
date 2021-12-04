//25-11-2021 03:54 PM

import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

AppBar? getAppBar(final ScreenTypes topScreen, final BuildContext context) {
  switch (topScreen) {
    case ScreenTypes.hidden:
      return AppBar(
        title: Text(Language.of(context).hidden),
        actions: const [AppBarAvatar()],
      );
    case ScreenTypes.home:
      return AppBar(
        title: Text(Language.of(context).home),
        actions: const [AppBarAvatar()],
      );

    case ScreenTypes.archive:
      return AppBar(
        title: Text(Language.of(context).archive),
        actions: const [AppBarAvatar()],
      );

    case ScreenTypes.backup:
      return AppBar(
        title: Text(Language.of(context).backup),
        actions: const [AppBarAvatar()],
      );

    case ScreenTypes.trash:
      return AppBar(
        title: Text(Language.of(context).trash),
        actions: const [AppBarAvatar()],
      );

    case ScreenTypes.aboutMe:
      return AppBar(
        title: Text(Language.of(context).about),
        actions: const [AppBarAvatar()],
      );
    case ScreenTypes.settings:
      return AppBar(
        title: Text(Language.of(context).settings),
        actions: const [AppBarAvatar()],
      );
    case ScreenTypes.welcome:
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
        backgroundColor: Theme.of(context).canvasColor,
      );
    default:
      return null;
  }
}