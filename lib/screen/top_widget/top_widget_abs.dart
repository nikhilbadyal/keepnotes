import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

enum ScreenTypes {
  suggestions,
  hidden,
  enterPin,
  setpass,
  home,
  archive,
  backup,
  trash,
  aboutMe,
  settings,
  welcome,
  login,
  forgotPassword,
  edit,
  signup
}

extension NoteInScreen on ScreenTypes {
  NoteState get getNoteSate {
    switch (this) {
      case ScreenTypes.hidden:
        return NoteState.hidden;

      case ScreenTypes.archive:
        return NoteState.archived;

      case ScreenTypes.trash:
        return NoteState.trashed;

      default:
        return NoteState.unspecified;
    }
  }
}

abstract class TopWidgetBase extends StatefulWidget {
  const TopWidgetBase({
    final Key? key,
  }) : super(key: key);

  BackPresAction? backPressAction();

  Widget? body(final BuildContext context);

  Widget? myDrawer(final BuildContext context);

  AppBar? appBar(final BuildContext context);

  Widget? floatingActionButton(final BuildContext context);

  @override
  _TopWidgetBaseState createState() => _TopWidgetBaseState();
}

class _TopWidgetBaseState extends State<TopWidgetBase> {
  @override
  Widget build(final BuildContext context) {
    return DoubleBackToCloseWidget(
      backPresAction: widget.backPressAction(),
      child: Scaffold(
        appBar: widget.appBar(context),
        drawer: widget.myDrawer(context),
        body: widget.body(context),
        floatingActionButton: widget.floatingActionButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }
}
