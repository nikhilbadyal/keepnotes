import 'package:flutter/material.dart';
import 'package:notes/model/Languages.dart';
import 'package:notes/model/Note.dart';
import 'package:notes/screen/edit/EditScreen.dart';
import 'package:notes/screen/lock/SetPassword.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/LockManager.dart';
import 'package:notes/util/Utilities.dart';
import 'package:provider/provider.dart';

Future navigate(String activeRoute, BuildContext context, String route,
    [Object? arguments]) async {
  if (activeRoute == route && route != AppRoutes.setpassScreen) {
    return Navigator.pop(context);
  }
  if (route == AppRoutes.homeScreen) {
    await Navigator.pushNamedAndRemoveUntil(context, route, (route) => false,
        arguments: arguments);
  } else {
    if (activeRoute == '/') {
      Navigator.pop(context);
      await Navigator.pushNamed(context, route, arguments: arguments);
    } else {
      await Navigator.pushReplacementNamed(context, route,
          arguments: arguments);
    }
  }
}

void goToBugScreen(BuildContext context) {
  Utilities.launchUrl(
    Utilities.emailLaunchUri.toString(),
  );
}

Future<void> goToNoteEditScreen(
    {required BuildContext context,
    required Note note,
    bool shouldAutoFocus = false}) async {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditScreen(
        currentNote: note,
        shouldAutoFocus: shouldAutoFocus,
      ),
    ),
  );
}

Future<void> goToHiddenScreen(BuildContext context, String activeRoute) async {
  if (ModalRoute.of(context)!.settings.name == AppRoutes.hiddenScreen) {
    Navigator.of(context).pop();
    return;
  }
  if (Provider.of<LockChecker>(context, listen: false).passwordSet) {
    if (Provider.of<LockChecker>(context, listen: false).bioEnabled &&
        !Provider.of<LockChecker>(context, listen: false).firstTimeNeeded &&
        Provider.of<LockChecker>(context, listen: false).fpDirectly) {
      final status = await Provider.of<LockChecker>(context, listen: false)
          .authenticateUser(context);
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
      AppRoutes.setpassScreen,
      DataObj(
        '',
        Language.of(context).enterNewPassword,
        isFirst: true,
      ),
    );
  }
}

class FadeInSlideOutRoute<T> extends MaterialPageRoute<T> {
  FadeInSlideOutRoute({required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (animation.status == AnimationStatus.reverse) {
      return super
          .buildTransitions(context, animation, secondaryAnimation, child);
    }

    return FadeTransition(opacity: animation, child: child);
  }
}
