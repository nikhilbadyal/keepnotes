import 'package:flutter/material.dart';
import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';

/// Extensions for general basic [Context]
extension ContextExtensions on BuildContext {
  /// To get a [MediaQuery] directly.
  MediaQueryData get mq => MediaQuery.of(this);

  /// Extension for getting Theme
  ThemeData get theme => Theme.of(this);

  Color get secondaryColor => Theme.of(this).colorScheme.secondary;

  /// Extension for navigation to next page
  /// Returns The state from the closest instance
  /// of this class that encloses the given context.
  ///
  /// It is used for routing in flutter
  ///
  NavigatorState get navigator => Navigator.of(this);

  LanguageModel get language => LanguageModel.of(this);

  ScaffoldMessengerState get sm => ScaffoldMessenger.of(this);

  String modalRouteSettingName<T>() {
    final modalRoute = ModalRoute.of<T>(this);
    return modalRoute!.settings.name ?? '/';
  }

  Object modalRouteArguments<T>() {
    final route = ModalRoute.of<T>(this);
    return route!.settings.arguments!;
  }

  FocusNode get focus => FocusScope.of(this);

  NotesHelper get noteHelper => Provider.of<NotesHelper>(this, listen: false);

  ///
  /// Removes the top most Widget in the navigator's stack
  ///
  /// Will return the [result] to the caller of [push]
  ///
  void previousPage<T>([final T? result]) => navigator.pop<T>(result);

  ///
  /// Pushes the built widget to the screen using the material fade in animation
  ///
  void nextPage(final String screenPath, {final Object? arguments}) =>
      _nextPage(context: this, page: screenPath, arguments: arguments);

  /// Pushes and replacing the built widget to the screen
  /// using the material fade in animation
  void nextReplacementPage(final String page, {final Object? arguments}) =>
      _nextReplacementPage(context: this, page: page, arguments: arguments);

  ///
  /// Returns the closest instance of [ScaffoldState] in the widget tree,
  /// which can be use to get information about that scaffold.
  ///
  /// If there is no [Scaffold] in scope, then this will throw an exception.
  ///
  ScaffoldState get scaffold => Scaffold.of(this);

  AppConfiguration get appConfig => Provider.of<AppConfiguration>(
        this,
        listen: false,
      );

  FirebaseAuthentication get firebaseAuth =>
      Provider.of<FirebaseAuthentication>(
        this,
        listen: false,
      );
}

Future<void> _nextPage({
  required final BuildContext context,
  required final String page,
  final Object? arguments,
}) async =>
    context.navigator.pushNamed(page, arguments: arguments);

Future<void> _nextReplacementPage({
  required final BuildContext context,
  required final String page,
  final Object? arguments,
}) async =>
    context.navigator.pushReplacementNamed(page, arguments: arguments);
