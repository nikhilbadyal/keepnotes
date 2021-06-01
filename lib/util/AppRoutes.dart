import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/animations/routing/BlurRoute.dart';
import 'package:notes/screen/lock/LockScreen.dart';
import 'package:notes/screen/lock/SetPassword.dart';
import 'package:notes/screen/topWidget/TopWidget.dart';
import 'package:notes/screen/topWidget/TopWidgetBase.dart';
import 'package:notes/util/ErrorScreen.dart';

class AppRoutes {
  static const hiddenScreen = '/hidden';
  static const lockScreen = '/lock';
  static const setpassScreen = '/setpass';
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
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Hidden,
            ),
          );
        }

      case AppRoutes.lockScreen:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const LockScreen(),
          );
        }

      case AppRoutes.homeScreen:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Home,
            ),
          );
        }

      case AppRoutes.archiveScreen:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Archive,
            ),
          );
        }

      case AppRoutes.backupScreen:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Backup,
            ),
          );
        }

      case AppRoutes.trashScreen:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Trash,
            ),
          );
        }

      case AppRoutes.aboutMeScreen:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.AboutMe,
            ),
          );
        }

      case AppRoutes.settingsScreen:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Settings,
            ),
          );
        }

      case AppRoutes.setpassScreen:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const SetPassword(),
          );
        }

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() =>
      BlurPageRoute(builder: (context) => const ErrorScreen());
}
