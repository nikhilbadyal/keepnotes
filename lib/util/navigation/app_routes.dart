import 'package:flutter/cupertino.dart';
import 'package:notes/_app_packages.dart';
import 'package:notes/_internal_packages.dart';
import 'package:notes/screen/welcome/forget_password.dart';

class AppRoutes {
  static const hiddenScreen = '/hidden';
  static const lockScreen = '/lock';
  static const setPassScreen = '/setpass';
  static const homeScreen = '/';
  static const archiveScreen = '/archive';
  static const backupScreen = '/backup';
  static const trashScreen = '/trash';
  static const aboutMeScreen = '/about';
  static const settingsScreen = '/settings';
  static const suggestScreen = '/suggestion';
  static const welcomeScreen = '/welcome';
  static const forgotPasswordScreen = '/forgot';
  static const editScreen = '/edit';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.hiddenScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.hidden,
            ),
          );
        }
      case AppRoutes.lockScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (_) => const LockScreen(),
          );
        }
      case AppRoutes.setPassScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (_) => const SetPassword(),
          );
        }
      case AppRoutes.homeScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.home,
            ),
          );
        }

      case AppRoutes.archiveScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.archive,
            ),
          );
        }

      case AppRoutes.backupScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.backup,
            ),
          );
        }

      case AppRoutes.trashScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.trash,
            ),
          );
        }

      case AppRoutes.aboutMeScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.aboutMe,
            ),
          );
        }

      case AppRoutes.settingsScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.settings,
            ),
          );
        }

      case AppRoutes.welcomeScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (_) => const Welcome(),
          );
        }
      case AppRoutes.forgotPasswordScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (_) => const ForgetPassword(),
          );
        }
      case AppRoutes.editScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (context) => const EditScreen(),
          );
        }
      default:
        return errorRoute();
    }
  }

  static Route<dynamic> errorRoute() {
    return CupertinoPageRoute(
      builder: (context) {
        return const ErrorScreen();
      },
    );
  }
}
