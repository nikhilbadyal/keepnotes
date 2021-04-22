import 'package:flutter/material.dart';
import 'package:notes/animations/routing/BlurRoute.dart';
import 'package:notes/screen/LockScreen.dart';
import 'package:notes/screen/SetPassword.dart';
import 'package:notes/screen/TopWidget.dart';
import 'package:notes/screen/TopWidgetBase.dart';
import 'package:notes/util/ErrorScreen.dart';

class NotesRoutes {
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
      case NotesRoutes.hiddenScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Hidden,
            ),
          );
        }

      case NotesRoutes.lockScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const LockScreen(),
          );
        }

      case NotesRoutes.homeScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Home,
            ),
          );
        }

      case NotesRoutes.archiveScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Archive,
            ),
          );
        }

      case NotesRoutes.backupScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Backup,
            ),
          );
        }

      case NotesRoutes.trashScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Trash,
            ),
          );
        }

      case NotesRoutes.aboutMeScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.AboutMe,
            ),
          );
        }

      case NotesRoutes.settingsScreen:
        {
          return BlurPageRoute(
            settings: settings,
            builder: (_) => const ScreenContainer(
              topScreen: ScreenTypes.Settings,
            ),
          );
        }

      case NotesRoutes.setpassScreen:
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

  static Route<dynamic> _errorRoute() {
    return BlurPageRoute(builder: (context) {
      return const ErrorScreen();
    });
  }
}
