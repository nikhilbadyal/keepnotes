import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

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
