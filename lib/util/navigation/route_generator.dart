import 'package:flutter/cupertino.dart';
import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

Route<dynamic> generateRoute(final RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.hiddenScreen:
      {
        return CupertinoPageRoute(
          settings: settings,
          builder: (final context) => const TopWidget(
            topScreen: ScreenTypes.hidden,
          ),
        );
      }
    case AppRoutes.lockScreen:
      {
        return CupertinoPageRoute(
          settings: settings,
          builder: (final context) => const TopWidget(
            topScreen: ScreenTypes.enterPin,
          ),
        );
      }
    case AppRoutes.setPassScreen:
      {
        return CupertinoPageRoute(
          settings: settings,
          builder: (final context) => const TopWidget(
            topScreen: ScreenTypes.setpass,
          ),
        );
      }
    case AppRoutes.homeScreen:
      {
        return CupertinoPageRoute(
          settings: settings,
          builder: (final context) => const TopWidget(
            topScreen: ScreenTypes.home,
          ),
        );
      }

    case AppRoutes.archiveScreen:
      {
        return CupertinoPageRoute(
          settings: settings,
          builder: (final context) => const TopWidget(
            topScreen: ScreenTypes.archive,
          ),
        );
      }

    case AppRoutes.trashScreen:
      {
        return CupertinoPageRoute(
          settings: settings,
          builder: (final context) => const TopWidget(
            topScreen: ScreenTypes.trash,
          ),
        );
      }

    case AppRoutes.aboutMeScreen:
      {
        return CupertinoPageRoute(
          settings: settings,
          builder: (final context) => const TopWidget(
            topScreen: ScreenTypes.aboutMe,
          ),
        );
      }

    case AppRoutes.settingsScreen:
      {
        return CupertinoPageRoute(
          settings: settings,
          builder: (final context) => const TopWidget(
            topScreen: ScreenTypes.settings,
          ),
        );
      }

    case AppRoutes.welcomeScreen:
      {
        return CupertinoPageRoute(
          settings: settings,
          builder: (final context) => const IntroScreen(),
        );
      }
    case AppRoutes.loginScreen:
      {
        return CupertinoPageRoute(
          settings: settings,
          builder: (final context) => const TopWidget(
            topScreen: ScreenTypes.login,
          ),
        );
      }
    case AppRoutes.forgotPasswordScreen:
      {
        return CupertinoPageRoute(
          settings: settings,
          builder: (final context) => const TopWidget(
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
          builder: (final context) => const TopWidget(
            topScreen: ScreenTypes.signup,
          ),
        );
      }
    default:
      return errorRoute();
  }
}

Route<dynamic> errorRoute() {
  return CupertinoPageRoute(
    builder: (final context) {
      return const ErrorScreen();
    },
  );
}

Future navigate(
  final String activeRoute,
  final BuildContext context,
  final String newRoute, [
  final Object? arguments,
]) async {
  Provider.of<NotesHelper>(context, listen: false).reset();
  if (activeRoute == newRoute && newRoute != AppRoutes.setPassScreen) {
    return Navigator.pop(context);
  }
  if (newRoute == AppRoutes.homeScreen) {
    await Navigator.pushNamedAndRemoveUntil(
      context,
      newRoute,
      (final route) {
        return false;
      },
      arguments: arguments,
    );
  } else {
    if (activeRoute == '/') {
      Navigator.pop(context);
      await Navigator.pushNamed(context, newRoute, arguments: arguments);
    } else {
      await Navigator.pushReplacementNamed(
        context,
        newRoute,
        arguments: arguments,
      );
    }
  }
}
