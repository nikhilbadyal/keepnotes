import 'package:flutter/cupertino.dart';
import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> with RouteAware {
  String _activeRoute = '/';

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
  Widget build(BuildContext context) {
    final wish = getWish(context);
    return Drawer(
      child: ListView(
        children: <Widget>[
          RepaintBoundary(
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).canvasColor),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(
                  'assets/images/${Provider.of<LockChecker>(context, listen: false).gender}.png',
                ),
              ),
              accountEmail: Text(
                wish,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).iconTheme.color),
              ),
              accountName: null,
              onDetailsPressed: () {
                unawaited(Provider.of<AppConfiguration>(context, listen: false)
                    .setHiddenDiscovered(true));
                goToHiddenScreen(context, _activeRoute);
              },
            ),
          ),
          const Divider(
            height: 0,
            color: Colors.grey,
          ),
          ListTile(
            leading: Icon(Icons.note,
                color: _activeRoute == AppRoutes.homeScreen
                    ? Theme.of(context).colorScheme.secondary
                    : null),
            title: Text(
              Language.of(context).home,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: _activeRoute == AppRoutes.homeScreen
                      ? Theme.of(context).colorScheme.secondary
                      : null),
            ),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.homeScreen, (route) => false);
            },
          ),
          ListTile(
            leading: Icon(Icons.archive_outlined,
                color: _activeRoute == AppRoutes.archiveScreen
                    ? Theme.of(context).colorScheme.secondary
                    : null),
            title: Text(
              Language.of(context).archive,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: _activeRoute == AppRoutes.archiveScreen
                      ? Theme.of(context).colorScheme.secondary
                      : null),
            ),
            onTap: () =>
                navigate(_activeRoute, context, AppRoutes.archiveScreen),
          ),
          const Divider(
            height: 15,
            color: Colors.transparent,
          ),
          ListTile(
            leading: Icon(Icons.settings_backup_restore,
                color: _activeRoute == AppRoutes.backupScreen
                    ? Theme.of(context).colorScheme.secondary
                    : null),
            title: Text(
              Language.of(context).backup,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: _activeRoute == AppRoutes.backupScreen
                      ? Theme.of(context).colorScheme.secondary
                      : null),
            ),
            onTap: () =>
                navigate(_activeRoute, context, AppRoutes.backupScreen),
          ),
          ListTile(
            leading: Icon(Icons.delete_outlined,
                color: _activeRoute == AppRoutes.trashScreen
                    ? Theme.of(context).colorScheme.secondary
                    : null),
            title: Text(
              Language.of(context).trash,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: _activeRoute == AppRoutes.trashScreen
                      ? Theme.of(context).colorScheme.secondary
                      : null),
            ),
            onTap: () => navigate(_activeRoute, context, AppRoutes.trashScreen),
          ),
          const Divider(
            height: 15,
            color: Colors.transparent,
          ),
          ListTile(
            leading: Icon(Icons.settings,
                color: _activeRoute == AppRoutes.settingsScreen
                    ? Theme.of(context).colorScheme.secondary
                    : null),
            title: Text(
              Language.of(context).settings,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: _activeRoute == AppRoutes.settingsScreen
                      ? Theme.of(context).colorScheme.secondary
                      : null),
            ),
            onTap: () =>
                navigate(_activeRoute, context, AppRoutes.settingsScreen),
          ),
          ListTile(
            leading: Icon(Icons.person_outline,
                color: _activeRoute == AppRoutes.aboutMeScreen
                    ? Theme.of(context).colorScheme.secondary
                    : null),
            title: Text(
              Language.of(context).about,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: _activeRoute == AppRoutes.aboutMeScreen
                      ? Theme.of(context).colorScheme.secondary
                      : null),
            ),
            onTap: () =>
                navigate(_activeRoute, context, AppRoutes.aboutMeScreen),
          ),
          ListTile(
            leading: Icon(Icons.bug_report_outlined,
                color: _activeRoute == AppRoutes.suggestScreen
                    ? Theme.of(context).colorScheme.secondary
                    : null),
            title: Text(
              Language.of(context).reportSuggest,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: _activeRoute == AppRoutes.suggestScreen
                      ? Theme.of(context).colorScheme.secondary
                      : null),
            ),
            onTap: () => goToBugScreen(context),
          ),
        ],
      ),
    );
  }

  String getWish(BuildContext context) {
    final hour = DateTime.now().hour;
    String wish;
    final startWish = Language.of(context).good;
    var gender = '${Language.of(context).queen} 👑';
    if (Provider.of<LockChecker>(context, listen: false).gender == 'men') {
      gender = '${Language.of(context).king} 👑';
    }
    if (hour >= 5 && hour <= 11) {
      wish = '$startWish ${Language.of(context).morning}, $gender';
    } else if (hour >= 12 && hour <= 17) {
      wish = '$startWish ${Language.of(context).afternoon}, $gender';
    } else {
      wish = '$startWish ${Language.of(context).night}, $gender';
    }
    if (!Provider.of<AppConfiguration>(context).isHiddenDiscovered) {
      wish += ' Tap me';
    }
    return wish;
  }
}
