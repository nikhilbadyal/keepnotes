import 'package:flutter/material.dart';
import 'package:notes/animations/routing/BlurRoute.dart';
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
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.hiddenScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Hidden,
            ),
          );
        }

      case AppRoutes.lockScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const LockScreen(),
          );
        }

      case AppRoutes.homeScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Home,
            ),
          );
        }

      case AppRoutes.archiveScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Archive,
            ),
          );
        }

      case AppRoutes.backupScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Backup,
            ),
          );
        }

      case AppRoutes.trashScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Trash,
            ),
          );
        }

      case AppRoutes.aboutMeScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.AboutMe,
            ),
          );
        }

      case AppRoutes.settingsScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Settings,
            ),
          );
        }

      case AppRoutes.setPassScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const SetPassword(),
          );
        }

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() =>
      BlurPageRoute(builder: (context) {
        return const ErrorScreen();
      });
}
