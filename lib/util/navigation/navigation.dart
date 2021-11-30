// ignore_for_file: use_build_context_synchronously
// TODO fix this ignore
import 'package:flutter/cupertino.dart';
import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class AppRoutes {
  static const suggestScreen = 'suggestion';
  static const hiddenScreen = 'hidden';
  static const lockScreen = 'lock';
  static const setPassScreen = 'setpass';
  static const homeScreen = '/';
  static const archiveScreen = 'archive';
  static const backupScreen = 'backup';
  static const trashScreen = 'trash';
  static const aboutMeScreen = 'about';
  static const settingsScreen = 'settings';
  static const welcomeScreen = 'welcome';
  static const loginScreen = 'login';
  static const forgotPasswordScreen = 'forgot';
  static const editScreen = 'edit';
  static const signUpScreen = 'signup';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(final RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.hiddenScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (final _) => const TopWidget(
              topScreen: ScreenTypes.hidden,
            ),
          );
        }
      case AppRoutes.lockScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (final _) => const TopWidget(
              topScreen: ScreenTypes.lock,
            ),
          );
        }
      case AppRoutes.setPassScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (final _) => const TopWidget(
              topScreen: ScreenTypes.setpass,
            ),
          );
        }
      case AppRoutes.homeScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (final _) => const TopWidget(
              topScreen: ScreenTypes.home,
            ),
          );
        }

      case AppRoutes.archiveScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (final _) => const TopWidget(
              topScreen: ScreenTypes.archive,
            ),
          );
        }

      case AppRoutes.backupScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (final _) => const TopWidget(
              topScreen: ScreenTypes.backup,
            ),
          );
        }

      case AppRoutes.trashScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (final _) => const TopWidget(
              topScreen: ScreenTypes.trash,
            ),
          );
        }

      case AppRoutes.aboutMeScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (final _) => const TopWidget(
              topScreen: ScreenTypes.aboutMe,
            ),
          );
        }

      case AppRoutes.settingsScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (final _) => const TopWidget(
              topScreen: ScreenTypes.settings,
            ),
          );
        }

      case AppRoutes.welcomeScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (final _) => const TopWidget(
              topScreen: ScreenTypes.welcome,
            ),
          );
        }
      case AppRoutes.loginScreen:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (final _) => const TopWidget(
              topScreen: ScreenTypes.login,
            ),
          );
        }
      case AppRoutes.forgotPasswordScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (final _) => const TopWidget(
              topScreen: ScreenTypes.forgotPassword,
            ),
          );
        }
      case AppRoutes.editScreen:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (final context) => const EditScreen(),
          );
        }
      case AppRoutes.signUpScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (final _) => const TopWidget(
              topScreen: ScreenTypes.signup,
            ),
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

Future navigate(final String activeRoute, final BuildContext context, final String newRoute,
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

Future<void> goToBugScreen(final BuildContext context) async {
  await launchUrl(
    context,
    emailLaunchUri.toString(),
  );
}

Future<void> goToNoteEditScreen({required final BuildContext context,
  required final Note note,
  final bool shouldAutoFocus = false}) async {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();

  await Navigator.pushNamed(context, AppRoutes.editScreen, arguments: note);
}

Future<void> goToHiddenScreen(final BuildContext context, final String activeRoute) async {
  final bioEnable = getBoolFromSF('bio') ?? false;
  final firstTime = getBoolFromSF('firstTimeNeeded') ?? false;
  final fpDirectly = getBoolFromSF('fpDirectly') ?? true;
  if (ModalRoute.of(context)!.settings.name == AppRoutes.hiddenScreen) {
    Navigator.of(context).pop();
    return;
  }
  if (Provider.of<LockChecker>(context, listen: false).password.isNotEmpty) {
    if (bioEnable && !firstTime && fpDirectly) {
      final status = await Provider.of<LockChecker>(context, listen: false)
          .authenticate(Language.of(context).localizedReason);
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
