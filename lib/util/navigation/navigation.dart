import 'package:flutter/cupertino.dart';
import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class AppRoutes {
  static const hiddenScreen = 'hidden';
  static const lockScreen = 'lock';
  static const setPassScreen = 'setpass';
  static const homeScreen = '/';
  static const archiveScreen = 'archive';
  static const backupScreen = 'backup';
  static const trashScreen = 'trash';
  static const aboutMeScreen = 'about';
  static const settingsScreen = 'settings';
  static const suggestScreen = 'suggestion';
  static const welcomeScreen = 'welcome';
  static const forgotPasswordScreen = 'forgot';
  static const editScreen = 'edit';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(final RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.hiddenScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (final _) => const ScreenContainer(
              topScreen: ScreenTypes.hidden,
            ),
          );
        }
      case AppRoutes.lockScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (final _) => const LockScreen(),
          );
        }
      case AppRoutes.setPassScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (final _) => const SetPassword(),
          );
        }
      case AppRoutes.homeScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (final _) => const ScreenContainer(
              topScreen: ScreenTypes.home,
            ),
          );
        }

      case AppRoutes.archiveScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (final _) => const ScreenContainer(
              topScreen: ScreenTypes.archive,
            ),
          );
        }

      case AppRoutes.backupScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (final _) => const ScreenContainer(
              topScreen: ScreenTypes.backup,
            ),
          );
        }

      case AppRoutes.trashScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (final _) => const ScreenContainer(
              topScreen: ScreenTypes.trash,
            ),
          );
        }

      case AppRoutes.aboutMeScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (final _) => const ScreenContainer(
              topScreen: ScreenTypes.aboutMe,
            ),
          );
        }

      case AppRoutes.settingsScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (final _) => const ScreenContainer(
              topScreen: ScreenTypes.settings,
            ),
          );
        }

      case AppRoutes.welcomeScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (final _) => const Welcome(),
          );
        }
      case AppRoutes.forgotPasswordScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (final _) => const ForgetPassword(),
          );
        }
      case AppRoutes.editScreen:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (final context) => const EditScreen(),
          );
        }
      default:
        return errorRoute();
    }
  }

  static Route<dynamic> errorRoute() {
    return CupertinoPageRoute(
      builder: (final context) {
        return const ErrorScreen();
      },
    );
  }
}

Future navigate(
    final String activeRoute, final BuildContext context, final String newRoute,
    [final Object? arguments]) async {
  Provider.of<NotesHelper>(context, listen: false).reset();
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
