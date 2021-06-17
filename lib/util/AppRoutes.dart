import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/screen/_screens.dart';
import 'package:notes/util/_util.dart';

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
  static const loginScreen = '/login';
  static const forgotPasswordScreen = '/forgot';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.hiddenScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Hidden,
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

      case AppRoutes.homeScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Home,
            ),
          );
        }

      case AppRoutes.archiveScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Archive,
            ),
          );
        }

      case AppRoutes.backupScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Backup,
            ),
          );
        }

      case AppRoutes.trashScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Trash,
            ),
          );
        }

      case AppRoutes.aboutMeScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.AboutMe,
            ),
          );
        }

      case AppRoutes.settingsScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Settings,
            ),
          );
        }

      case AppRoutes.setPassScreen:
        {
          return CupertinoPageRoute(
            settings: settings,
            builder: (_) => const SetPassword(),
          );
        }

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() => CupertinoPageRoute(builder: (context) {
        return const ErrorScreen();
      });
}
