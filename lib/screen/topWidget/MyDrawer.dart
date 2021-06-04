import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/app.dart';
import 'package:notes/model/Languages.dart';
import 'package:notes/util/AppConfiguration.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/LockManager.dart';
import 'package:notes/util/Navigations.dart';
import 'package:provider/provider.dart';

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
    _activeRoute = ModalRoute.of(context)!.settings.name!;
  }

  @override
  Widget build(BuildContext context) {
    final wish = getWish(context);
    return Drawer(
      child: ListView(
        children: <Widget>[
          RepaintBoundary(
            child: UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(
                  'assets/images/${Provider.of<LockChecker>(context, listen: false).gender}.png',
                ),
              ),
              accountEmail: Text(wish,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  )),
              accountName: const Text(''),
              onDetailsPressed: () => goToHiddenScreen(context, _activeRoute),
            ),
          ),
          ListTile(
            leading: Icon(Icons.note,
                color: _activeRoute == AppRoutes.homeScreen
                    ? Theme.of(context).accentColor
                    : null),
            title: Text(
              Language.of(context).home,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: _activeRoute == AppRoutes.homeScreen
                      ? Provider.of<AppConfiguration>(context, listen: false)
                          .primaryColor
                      : null),
            ),
            // selected: _activeRoute == AppRoutes.homeScreen,
            onTap: () => navigate(_activeRoute, context, AppRoutes.homeScreen),
          ),
          ListTile(
            leading: Icon(Icons.archive_outlined,
                color: _activeRoute == AppRoutes.archiveScreen
                    ? Theme.of(context).accentColor
                    : null),
            title: Text(
              Language.of(context).archive,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: _activeRoute == AppRoutes.archiveScreen
                      ? Provider.of<AppConfiguration>(context, listen: false)
                          .primaryColor
                      : null),
            ),
            onTap: () =>
                navigate(_activeRoute, context, AppRoutes.archiveScreen),
          ),
          ListTile(
            leading: Icon(Icons.settings_backup_restore,
                color: _activeRoute == AppRoutes.backupScreen
                    ? Theme.of(context).accentColor
                    : null),
            title: Text(
              Language.of(context).backup,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: _activeRoute == AppRoutes.backupScreen
                      ? Provider.of<AppConfiguration>(context, listen: false)
                          .primaryColor
                      : null),
            ),
            onTap: () =>
                navigate(_activeRoute, context, AppRoutes.backupScreen),
          ),
          ListTile(
            leading: Icon(Icons.delete_outlined,
                color: _activeRoute == AppRoutes.trashScreen
                    ? Theme.of(context).accentColor
                    : null),
            title: Text(
              Language.of(context).trash,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: _activeRoute == AppRoutes.trashScreen
                      ? Provider.of<AppConfiguration>(context, listen: false)
                          .primaryColor
                      : null),
            ),
            onTap: () => navigate(_activeRoute, context, AppRoutes.trashScreen),
          ),
          ListTile(
            leading: Icon(Icons.settings,
                color: _activeRoute == AppRoutes.settingsScreen
                    ? Theme.of(context).accentColor
                    : null),
            title: Text(
              Language.of(context).settings,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: _activeRoute == AppRoutes.settingsScreen
                      ? Provider.of<AppConfiguration>(context, listen: false)
                          .primaryColor
                      : null),
            ),
            onTap: () =>
                navigate(_activeRoute, context, AppRoutes.settingsScreen),
          ),
          ListTile(
            leading: Icon(Icons.person_outline,
                color: _activeRoute == AppRoutes.aboutMeScreen
                    ? Theme.of(context).accentColor
                    : null),
            title: Text(
              Language.of(context).about,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: _activeRoute == AppRoutes.aboutMeScreen
                      ? Provider.of<AppConfiguration>(context, listen: false)
                          .primaryColor
                      : null),
            ),
            onTap: () =>
                navigate(_activeRoute, context, AppRoutes.aboutMeScreen),
          ),
          ListTile(
            leading: Icon(Icons.email_outlined,
                color: _activeRoute == AppRoutes.suggestScreen
                    ? Theme.of(context).accentColor
                    : null),
            title: Text(
              Language.of(context).reportSuggest,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: _activeRoute == AppRoutes.suggestScreen
                      ? Provider.of<AppConfiguration>(context, listen: false)
                          .primaryColor
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
    return wish;
  }
}
