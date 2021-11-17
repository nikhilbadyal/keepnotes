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

abstract class TopWidgetBase extends StatefulWidget {
  const TopWidgetBase({Key? key}) : super(key: key);

  Widget? body(BuildContext context);

  Widget? myDrawer(BuildContext context);

  MyAppBar? appBar(BuildContext context);

  Widget? floatingActionButton(BuildContext context);

  @override
  _TopWidgetBaseState createState() => _TopWidgetBaseState();
}

class _TopWidgetBaseState extends State<TopWidgetBase> {
  @override
  Widget build(BuildContext context) {
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
