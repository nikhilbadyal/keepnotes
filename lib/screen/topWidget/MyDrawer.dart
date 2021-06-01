import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/app.dart';
import 'package:notes/model/Languages.dart';
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
            leading: const Icon(
              Icons.note,
            ),
            title: Text(
              Language.of(context).home,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            selected: _activeRoute == AppRoutes.homeScreen,
            onTap: () => navigate(_activeRoute, context, AppRoutes.homeScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.archive_outlined,
            ),
            title: Text(
              Language.of(context).archive,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            selected: _activeRoute == AppRoutes.archiveScreen,
            onTap: () =>
                navigate(_activeRoute, context, AppRoutes.archiveScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.settings_backup_restore,
            ),
            title: Text(
              Language.of(context).backup,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            selected: _activeRoute == AppRoutes.backupScreen,
            onTap: () =>
                navigate(_activeRoute, context, AppRoutes.backupScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.delete_outlined,
            ),
            title: Text(
              Language.of(context).trash,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            selected: _activeRoute == AppRoutes.trashScreen,
            onTap: () => navigate(_activeRoute, context, AppRoutes.trashScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
            ),
            title: Text(
              Language.of(context).settings,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            selected: _activeRoute == AppRoutes.settingsScreen,
            onTap: () =>
                navigate(_activeRoute, context, AppRoutes.settingsScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.person_outline,
            ),
            title: Text(
              Language.of(context).about,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            selected: _activeRoute == AppRoutes.aboutMeScreen,
            onTap: () =>
                navigate(_activeRoute, context, AppRoutes.aboutMeScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.email_outlined,
            ),
            title: Text(
              Language.of(context).reportSuggest,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            selected: _activeRoute == AppRoutes.suggestScreen,
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
