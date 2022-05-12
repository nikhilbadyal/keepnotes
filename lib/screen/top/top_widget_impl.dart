import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

class TopWidget extends TopWidgetBase {
  const TopWidget({
    required this.topScreen,
    final Key? key,
  }) : super(key: key);
  final ScreenTypes topScreen;

  @override
  Widget? myDrawer(final BuildContext context) => getDrawer(topScreen, context);

  @override
  AppBar? appBar(final BuildContext context) => getAppBar(topScreen, context);

  @override
  Widget? floatingActionButton(final BuildContext context) =>
      getFAB(topScreen, context);

  @override
  Widget body(final BuildContext context) => getBody(topScreen, context);

  Future<bool> allowBack() {
    return Future.value(true);
  }

  @override
  BackPresAction? backPressAction() {
    switch (topScreen) {
      case ScreenTypes.login:
      case ScreenTypes.forgotPassword:
      case ScreenTypes.signup:
      case ScreenTypes.intro:
        return allowBack;
      default:
        return null;
    }
  }
}
