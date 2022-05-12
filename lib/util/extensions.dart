import 'package:flutter/cupertino.dart' show CupertinoTheme, CupertinoThemeData;
import 'package:flutter/material.dart';
import 'package:notes/_aap_packages.dart';

/// Extensions for general basic [Context]
extension ContextExtensions on BuildContext {
  /// To get a [MediaQuery] directly.
  MediaQueryData get mq => MediaQuery.of(this);

  /// Get MediaQuery Screen Size
  Size get screenSize => mq.size;

  /// Get MediaQuery Screen Density
  double get screenDensity => mq.devicePixelRatio;

  /// Get MediaQuery Screen Padding
  EdgeInsets get screenPadding => mq.padding;

  /// Get MediaQuery Screen Width
  double get screenWidth => mq.size.width;

  /// Get MediaQuery Screen Height
  double get screenHeight => mq.size.height;

  /// Get MediaQuery Screen Width in percentage
  double get percentWidth => screenWidth / 100;

  /// Get MediaQuery Screen height in percentage
  double get percentHeight => screenHeight / 100;

  /// Get MediaQuery safearea padding horizontally
  double get _safeAreaHorizontal => mq.padding.left + mq.padding.right;

  /// Get MediaQuery safearea padding vertically
  double get _safeAreaVertical => mq.padding.top + mq.padding.bottom;

  /// Get MediaQuery Screen Width in percentage including safe area calculation.
  double get safePercentWidth => (screenWidth - _safeAreaHorizontal) / 100;

  /// Get MediaQuery Screen Height in percentage including
  /// safe area calculation.
  double get safePercentHeight => (screenHeight - _safeAreaVertical) / 100;

  ///Returns Orientation using [MediaQuery]
  Orientation get orientation => mq.orientation;

  /// Returns if Orientation is landscape
  bool get isLandscape => orientation == Orientation.landscape;

  /// Extension for getting Theme
  ThemeData get theme => Theme.of(this);

  /// Extension for getting [CupertinoThemeData]
  CupertinoThemeData get cupertinoTheme => CupertinoTheme.of(this);

  /// Extension for getting textTheme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Extension for getting textTheme
  TextStyle? get captionStyle => Theme.of(this).textTheme.caption;

  ///
  /// The foreground color for widgets
  /// (knobs, text, overscroll edge effect, etc).
  ///
  /// Accent color is also known as the secondary color.
  ///
  Color get accentColor => theme.colorScheme.secondary;

  ///
  /// The background color for major parts of the app (toolbars, tab bars, etc).
  ///
  Color get primaryColor => theme.primaryColor;

  ///
  /// A color that contrasts with the [primaryColor].
  ///
  Color get backgroundColor => theme.backgroundColor;

  ///
  /// The default color of [MaterialType.canvas] [Material].
  ///
  Color get canvasColor => theme.canvasColor;

  ///
  /// The default color of [MaterialType.card] [Material].
  ///
  Color get cardColor => theme.cardColor;

  ///
  /// The default brightness of the [Theme].
  ///
  Brightness get brightness => theme.brightness;

  /// If the [ThemeData] of the current [BuildContext] is dark
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Extension for navigation to next page
  /// Returns The state from the closest instance
  /// of this class that encloses the given context.
  ///
  /// It is used for routing in flutter
  ///
  NavigatorState get navigator => Navigator.of(this);

  Language get language => Language.of(this);

  ScaffoldMessengerState get sm => ScaffoldMessenger.of(this);

  String modalRouteSettingName<T>() {
    final modalRoute = ModalRoute.of<T>(this);
    return modalRoute!.settings.name ?? '/';
  }

  Object modalRouteArguments<T>() {
    final lol = ModalRoute.of<T>(this);
    return lol!.settings.arguments!;
  }

  FocusNode get focus => FocusScope.of(this);

  ///
  /// Pushes the built widget to the screen using the material fade in animation
  ///
  /// Will return a value when the built widget calls [pop]
  ///
  Future<T?> push<T>(final WidgetBuilder builder) async {
    return navigator.push<T>(MaterialPageRoute(builder: builder));
  }

  void popUntil(final RoutePredicate predicate) {}

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

  /// Action Extension
  bool? invokeAction(final Intent intent) =>
      Actions.invoke(this, intent) as bool?;

  /// Returns The state from the closest instance of
  /// this class that encloses the given context.
  /// It is used for validating forms
  FormState? get form => Form.of(this);

  ///
  /// Returns The current [Locale] of the app
  /// as specified in the [Localizations] widget.
  ///
  Locale? get vxlocale => Localizations.localeOf(this);

  /// Returns The state from the closest instance
  /// of this class that encloses the given context.
  ///
  /// It is used for showing widgets on top of everything.
  ///
  OverlayState? get overlay => Overlay.of(this);

  ///
  /// Insert the given widget into the overlay.
  /// The newly inserted widget will always be at the top.
  ///
  OverlayEntry addOverlay(final WidgetBuilder builder) {
    final entry = OverlayEntry(builder: builder);
    overlay!.insert(entry);
    return entry;
  }

  ///
  /// Returns the closest instance of [ScaffoldState] in the widget tree,
  /// which can be use to get information about that scaffold.
  ///
  /// If there is no [Scaffold] in scope, then this will throw an exception.
  ///
  ScaffoldState get scaffold => Scaffold.of(this);
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
