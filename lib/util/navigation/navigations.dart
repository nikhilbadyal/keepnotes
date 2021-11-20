import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

Future navigate(
    final String activeRoute, final BuildContext context, final String newRoute,
    [final Object? arguments]) async {
  if (activeRoute == newRoute && newRoute != AppRoutes.setPassScreen) {
    return Navigator.pop(context);
  }
  if (newRoute == AppRoutes.homeScreen) {
    await Navigator.pushNamedAndRemoveUntil(context, newRoute, (final route) {
      return false;
    }, arguments: arguments);
  } else {
    if (activeRoute == '/') {
      Navigator.pop(context);
      await Navigator.pushNamed(context, newRoute, arguments: arguments);
    } else {
      await Navigator.pushReplacementNamed(context, newRoute,
          arguments: arguments);
    }
  }
}

void goToBugScreen(final BuildContext context) {
  Utilities.launchUrl(
    context,
    Utilities.emailLaunchUri.toString(),
  );
}

Future<void> goToNoteEditScreen(
    {required final BuildContext context,
    required final Note note,
    final bool shouldAutoFocus = false}) async {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();

  await Navigator.pushNamed(context, AppRoutes.editScreen, arguments: note);
}

Future<void> goToHiddenScreen(
    final BuildContext context, final String activeRoute) async {
  final bioEnable = getBoolFromSF('bio') ?? false;
  final firstTime = getBoolFromSF('firstTimeNeeded') ?? false;
  final fpDirectly = getBoolFromSF('fpDirectly') ?? false;
  if (ModalRoute.of(context)!.settings.name == AppRoutes.hiddenScreen) {
    Navigator.of(context).pop();
    return;
  }
  if (Provider.of<LockChecker>(context, listen: false).password.isNotEmpty) {
    if (bioEnable && !firstTime && fpDirectly) {
      final status = await Provider.of<LockChecker>(context, listen: false)
          .authenticate(context);
      if (status) {
        await navigate(ModalRoute.of(context)!.settings.name!, context,
            AppRoutes.hiddenScreen);
        return;
      }
    }
    await navigate(
      activeRoute,
      context,
      AppRoutes.lockScreen,
      false,
    );
  } else {
    await navigate(
      activeRoute,
      context,
      AppRoutes.setPassScreen,
      DataObj(
        '',
        Language.of(context).enterNewPassword,
        isFirst: true,
      ),
    );
  }
}
