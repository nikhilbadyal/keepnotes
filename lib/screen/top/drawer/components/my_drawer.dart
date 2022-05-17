import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

var isOpened = false;

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    final Key? key,
  }) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> with RouteAware {
  String _activeRoute = '/';
  var gender = getStringFromSF('gender') ?? 'men';
  var isHiddenDiscovered = getBoolFromSF('hiddenDiscovered') ?? false;

  @override
  void initState() {
    super.initState();
    isOpened = true;
  }

  @override
  void dispose() {
    super.dispose();
    isOpened = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
      this,
      ModalRoute.of(context)!,
    );
  }

  @override
  void didPush() {
    _activeRoute = context.modalRouteSettingName();
  }

  @override
  Widget build(final BuildContext context) {
    final wish = getWish(context);
    return Drawer(
      child: ListView(
        children: <Widget>[
          RepaintBoundary(
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: context.canvasColor,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Image.asset(
                  '$imageAssets$gender.png',
                ),
              ),
              accountEmail: Text(
                wish,
                style: TextStyle(
                  fontSize: 15,
                  color: context.iconColor,
                ),
              ),
              accountName: null,
              onDetailsPressed: () async {
                unawaited(
                  context.appConfig.setHiddenDiscovered(),
                );
                final bioEnable = getBoolFromSF('bio') ?? false;
                final firstTime = getBoolFromSF('firstTimeNeeded') ?? false;
                final fpDirectly = getBoolFromSF('fpDirectly') ?? true;
                if (context.modalRouteSettingName() == AppRoutes.hiddenScreen) {
                  context.previousPage();
                  return;
                }
                if (context.appConfig.password.isNotEmpty) {
                  if (bioEnable && !firstTime && fpDirectly) {
                    final status = await context.appConfig.authenticate(
                      context.language.localizedReason,
                    );
                    if (!mounted) {
                      return;
                    }
                    if (status) {
                      await navigate(
                        context.modalRouteSettingName(),
                        context,
                        AppRoutes.hiddenScreen,
                      );
                      return;
                    }
                  }
                  if (!mounted) {
                    return;
                  }

                  await navigate(
                    _activeRoute,
                    context,
                    AppRoutes.lockScreen,
                    false,
                  );
                } else {
                  await navigate(
                    _activeRoute,
                    context,
                    AppRoutes.setPassScreen,
                    DataObj(
                      '',
                      context.language.enterNewPassword,
                      isFirst: true,
                    ),
                  );
                }
              },
            ),
          ),
          const Divider(
            height: 0,
            color: Colors.grey,
          ),
          ListTile(
            leading: Icon(
              Icons.notes,
              color: _activeRoute == AppRoutes.homeScreen
                  ? context.secondaryColor
                  : null,
            ),
            title: Text(
              context.language.home,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: _activeRoute == AppRoutes.homeScreen
                    ? context.secondaryColor
                    : null,
              ),
            ),
            onTap: () {
              navigate(_activeRoute, context, AppRoutes.homeScreen);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.archive_outlined,
              color: _activeRoute == AppRoutes.archiveScreen
                  ? context.secondaryColor
                  : null,
            ),
            title: Text(
              context.language.archive,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: _activeRoute == AppRoutes.archiveScreen
                    ? context.secondaryColor
                    : null,
              ),
            ),
            onTap: () {
              navigate(_activeRoute, context, AppRoutes.archiveScreen);
            },
          ),
          const Divider(
            height: 15,
            color: Colors.transparent,
          ),
          ListTile(
            leading: Icon(
              Icons.delete_outlined,
              color: _activeRoute == AppRoutes.trashScreen
                  ? context.secondaryColor
                  : null,
            ),
            title: Text(
              context.language.trash,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: _activeRoute == AppRoutes.trashScreen
                    ? context.secondaryColor
                    : null,
              ),
            ),
            onTap: () => navigate(_activeRoute, context, AppRoutes.trashScreen),
          ),
          const Divider(
            height: 15,
            color: Colors.transparent,
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: _activeRoute == AppRoutes.settingsScreen
                  ? context.secondaryColor
                  : null,
            ),
            title: Text(
              context.language.settings,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: _activeRoute == AppRoutes.settingsScreen
                    ? context.secondaryColor
                    : null,
              ),
            ),
            onTap: () =>
                navigate(_activeRoute, context, AppRoutes.settingsScreen),
          ),
          ListTile(
            leading: Icon(
              Icons.person_outline,
              color: _activeRoute == AppRoutes.aboutMeScreen
                  ? context.secondaryColor
                  : null,
            ),
            title: Text(
              context.language.about,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: _activeRoute == AppRoutes.aboutMeScreen
                    ? context.secondaryColor
                    : null,
              ),
            ),
            onTap: () =>
                navigate(_activeRoute, context, AppRoutes.aboutMeScreen),
          ),
          ListTile(
            leading: Icon(
              Icons.bug_report_outlined,
              color: _activeRoute == AppRoutes.suggestScreen
                  ? context.secondaryColor
                  : null,
            ),
            title: Text(
              context.language.reportSuggest,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: _activeRoute == AppRoutes.suggestScreen
                    ? context.secondaryColor
                    : null,
              ),
            ),
            onTap: () async => urlLauncher(
              emailLaunchUri.toString(),
            ),
          ),
        ],
      ),
    );
  }

  String getWish(
    final BuildContext context, {
    final bool? undiscovered,
  }) {
    final hour = DateTime.now().hour;
    String wish;
    final startWish = context.language.good;
    if (hour >= 5 && hour <= 11) {
      wish = '$startWish ${context.language.morning}';
    } else if (hour >= 12 && hour <= 17) {
      wish = '$startWish ${context.language.afternoon}';
    } else {
      wish = '$startWish ${context.language.night}';
    }
    if (undiscovered ?? !isHiddenDiscovered) {
      wish += context.language.tapMe;
    }
    return wish;
  }
}
