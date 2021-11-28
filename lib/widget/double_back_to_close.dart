import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class DoubleBackToCloseWidget extends StatefulWidget {
  const DoubleBackToCloseWidget(
      {required this.child, final Key? key, final this.backPresAction})
      : super(key: key);

  final Widget child;
  final BackPresAction? backPresAction;

  static const exitTimeInMillis = 1500;

  @override
  _DoubleBackToCloseWidgetState createState() =>
      _DoubleBackToCloseWidgetState();
}

class _DoubleBackToCloseWidgetState extends State<DoubleBackToCloseWidget> {
  int _lastTimeBackButtonWasTapped = 0;

  @override
  Widget build(final BuildContext context) {
    final _isAndroid = Theme.of(context).platform == TargetPlatform.android;
    if (_isAndroid) {
      return WillPopScope(
        onWillPop: widget.backPresAction ?? defaultBackPress,
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }

  int getNotesType(final String appRoutes) {
    switch (appRoutes) {
      case AppRoutes.hiddenScreen:
        return NoteState.hidden.index;

      case AppRoutes.archiveScreen:
        return NoteState.archived.index;

      case AppRoutes.trashScreen:
        return NoteState.deleted.index;

      default:
        return NoteState.unspecified.index;
    }
  }

  Future<bool> defaultBackPress() async {
    Provider.of<NotesHelper>(context, listen: false).reset();
    await Provider.of<NotesHelper>(context, listen: false)
        .getAllNotes(NoteState.unspecified.index, clear: true);

    if (!mounted) {
      return true;
    }
    Provider.of<NotesHelper>(context, listen: false).notify();
    final _currentTime = DateTime.now().millisecondsSinceEpoch;
    if ((_currentTime - _lastTimeBackButtonWasTapped) <
        DoubleBackToCloseWidget.exitTimeInMillis) {
      return Future.value(true);
    } else {
      _lastTimeBackButtonWasTapped = DateTime.now().millisecondsSinceEpoch;
      if (ModalRoute.of(context)!.settings.name! == AppRoutes.lockScreen ||
          ModalRoute.of(context)!.settings.name! == AppRoutes.setPassScreen) {
        Navigator.of(context).popUntil(
            (final route) => route.settings.name == AppRoutes.homeScreen);
        return Future.value(true);
      } else if (ModalRoute.of(context)!.settings.name! ==
              AppRoutes.homeScreen &&
          !isOpened) {
        Utilities.showSnackbar(context, Language.of(context).doubleBackToExit,
            snackBarBehavior: SnackBarBehavior.fixed,
            duration: const Duration(
                milliseconds: DoubleBackToCloseWidget.exitTimeInMillis - 10));
        return Future.value(false);
      } else {
        return Future.value(true);
      }
    }
  }
}
