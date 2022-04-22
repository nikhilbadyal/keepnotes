import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

var isOpened = false;

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    final Key? key,
  }) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
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
    _activeRoute = ModalRoute.of(context)!.settings.name ?? '/';
  }

  @override
  Widget build(final BuildContext context) {
    final wish = getWish(context);
    return Drawer(
      child: ListView(
        children: <Widget>[
          RepaintBoundary(
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).canvasColor),
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
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              accountName: null,
              onDetailsPressed: () async {
                unawaited(
                  Provider.of<AppConfiguration>(context, listen: false)
                      .setHiddenDiscovered(),
                );
                final bioEnable = getBoolFromSF('bio') ?? false;
                final firstTime = getBoolFromSF('firstTimeNeeded') ?? false;
                final fpDirectly = getBoolFromSF('fpDirectly') ?? true;
                if (ModalRoute.of(context)!.settings.name ==
                    AppRoutes.hiddenScreen) {
                  Navigator.of(context).pop();
                  return;
                }
                if (Provider.of<AppConfiguration>(context, listen: false)
                    .password
                    .isNotEmpty) {
                  if (bioEnable && !firstTime && fpDirectly) {
                    final status = await Provider.of<AppConfiguration>(
                      context,
                      listen: false,
                    ).authenticate(Language.of(context).localizedReason);
                    if (!mounted) {
                      return;
                    }
                    if (status) {
                      await navigate(
                        ModalRoute.of(context)!.settings.name!,
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
                      Language.of(context).enterNewPassword,
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
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
            title: Text(
              Language.of(context).home,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: _activeRoute == AppRoutes.homeScreen
                    ? Theme.of(context).colorScheme.secondary
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
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
            title: Text(
              Language.of(context).archive,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: _activeRoute == AppRoutes.archiveScreen
                    ? Theme.of(context).colorScheme.secondary
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
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
            title: Text(
              Language.of(context).trash,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: _activeRoute == AppRoutes.trashScreen
                    ? Theme.of(context).colorScheme.secondary
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
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
            title: Text(
              Language.of(context).settings,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: _activeRoute == AppRoutes.settingsScreen
                    ? Theme.of(context).colorScheme.secondary
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
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
            title: Text(
              Language.of(context).about,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: _activeRoute == AppRoutes.aboutMeScreen
                    ? Theme.of(context).colorScheme.secondary
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
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
            title: Text(
              Language.of(context).reportSuggest,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: _activeRoute == AppRoutes.suggestScreen
                    ? Theme.of(context).colorScheme.secondary
                    : null,
              ),
            ),
            onTap: () async => launchUrl(
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
    final startWish = Language.of(context).good;
    if (hour >= 5 && hour <= 11) {
      wish = '$startWish ${Language.of(context).morning}';
    } else if (hour >= 12 && hour <= 17) {
      wish = '$startWish ${Language.of(context).afternoon}';
    } else {
      wish = '$startWish ${Language.of(context).night}';
    }
    if (undiscovered ?? !isHiddenDiscovered) {
      wish += Language.of(context).tapMe;
    }
    return wish;
  }
}
