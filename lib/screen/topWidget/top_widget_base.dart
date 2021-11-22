import 'package:notes/_app_packages.dart';
import 'package:notes/_internal_packages.dart';

enum ScreenTypes {
  hidden,
  lock,
  setpass,
  home,
  archive,
  backup,
  trash,
  aboutMe,
  settings,
  suggestions,
}

typedef ActionFunction = void Function(
    BuildContext context, Note note, OnTapCallback);
typedef OnTapCallback = void Function(BuildContext context, Note note);

abstract class ScreenContainerBase extends StatefulWidget {
  const ScreenContainerBase({final Key? key}) : super(key: key);

  Widget? body(final BuildContext context);

  Widget? myDrawer(final BuildContext context);

  MyAppBar? appBar(final BuildContext context);

  Widget? floatingActionButton(final BuildContext context);

  @override
  _ScreenContainerBaseState createState() => _ScreenContainerBaseState();
}

class _ScreenContainerBaseState extends State<ScreenContainerBase> {
  @override
  Widget build(final BuildContext context) {
    return DoubleBackToCloseWidget(
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
