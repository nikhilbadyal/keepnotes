import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class DoubleBackToCloseWidget extends StatefulWidget {
  const DoubleBackToCloseWidget({
    required this.child,
    final Key? key,
    final this.backPresAction,
  }) : super(key: key);

  final Widget child;
  final BackPresAction? backPresAction;

  @override
  _DoubleBackToCloseWidgetState createState() =>
      _DoubleBackToCloseWidgetState();
}

class _DoubleBackToCloseWidgetState extends State<DoubleBackToCloseWidget> {
  int _lastTimeBackButtonWasTapped = 0;

  @override
  Widget build(final BuildContext context) {
    final isAndroid = context.theme.platform == TargetPlatform.android;
    if (isAndroid) {
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
        return NoteState.trashed.index;

      default:
        return NoteState.unspecified.index;
    }
  }

  Future<bool> defaultBackPress() async {
    Provider.of<NotesHelper>(context, listen: false).reset();
    await Provider.of<NotesHelper>(context, listen: false)
        .getAllNotes(NoteState.unspecified.index);

    if (!mounted) {
      return true;
    }
    Provider.of<NotesHelper>(context, listen: false).notify();
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    if ((currentTime - _lastTimeBackButtonWasTapped) < exitTimeInMillis) {
      return Future.value(true);
    } else {
      _lastTimeBackButtonWasTapped = DateTime.now().millisecondsSinceEpoch;
      if (context.modalRouteSettingName() == AppRoutes.lockScreen ||
          context.modalRouteSettingName() == AppRoutes.setPassScreen) {
        context.navigator.popUntil(
          ModalRoute.withName(AppRoutes.homeScreen),
        );
        return Future.value(true);
      } else if (context.modalRouteSettingName() == AppRoutes.homeScreen &&
          !isOpened) {
        showSnackbar(
          context,
          context.language.doubleBackToExit,
          snackBarBehavior: SnackBarBehavior.fixed,
          duration: const Duration(milliseconds: exitTimeInMillis - 10),
        );
        return Future.value(false);
      } else {
        return Future.value(true);
      }
    }
  }
}
