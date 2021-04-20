import 'package:flutter/material.dart';
import 'package:notes/app.dart';
import 'package:notes/model/Note.dart';
import 'package:notes/screen/EditScreen.dart';
import 'package:notes/screen/SetPassword.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/Utilites.dart';

Future navigate(String activeRoute, BuildContext context, String route,
    [Object? arguments]) async {
  if (activeRoute == route && route != NotesRoutes.setpassScreen) {
    return Navigator.pop(context);
  }
  if (route == NotesRoutes.homeScreen) {
    // TODO i can also do pop until here
    await Navigator.pushNamedAndRemoveUntil(
        context, route, (Route<dynamic> route) => false,
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
  //debugPrint('launching');
  Utilities.launchUrl(
    Utilities.emailLaunchUri.toString(),
  );
}

Future<void> goToNoteEditScreen(
    {required BuildContext context,
    required Note note,
    shouldAutoFocus = false}) async {
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
  if (ModalRoute.of(context)!.settings.name == NotesRoutes.hiddenScreen) {
    Navigator.of(context).pop();
    return;
  }
  if (myNotes.lockChecker.passwordSet) {
    if (myNotes.lockChecker.bioEnabled &&
        !myNotes.lockChecker.firstTimeNeeded &&
        myNotes.lockChecker.fpDirectly) {
      final status = await myNotes.lockChecker.authenticateUser(context);
      if (status) {
        await navigate(ModalRoute.of(context)!.settings.name!, context,
            NotesRoutes.hiddenScreen);
        return;
      }
    }
    await navigate(
      activeRoute,
      context,
      NotesRoutes.lockScreen,
      false,
    );
  } else {
    await navigate(
      activeRoute,
      context,
      NotesRoutes.setpassScreen,
      DataObj(true, '', 'Enter New Password'),
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
