import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/app.dart';
import 'package:notes/main.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/Languages/Languages.dart';
import 'package:notes/util/Navigations.dart';

class MyDrawer extends StatefulWidget {
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
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(
                'assets/images/${lockChecker.gender}.png',
              ),
            ),
            accountEmail: Text(
              wish,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            accountName: const Text(''),
            onDetailsPressed: () => goToHiddenScreen(context, _activeRoute),
          ),
          ListTile(
            leading: const Icon(
              Icons.note,
            ),
            title: Text(
              Languages.of(context).home,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            selected: _activeRoute == NotesRoutes.homeScreen,
            onTap: () =>
                navigate(_activeRoute, context, NotesRoutes.homeScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.archive_outlined,
            ),
            title: Text(
              Languages.of(context).archive,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            selected: _activeRoute == NotesRoutes.archiveScreen,
            onTap: () =>
                navigate(_activeRoute, context, NotesRoutes.archiveScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.settings_backup_restore,
            ),
            title: Text(
              Languages.of(context).backup,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            selected: _activeRoute == NotesRoutes.backupScreen,
            onTap: () =>
                navigate(_activeRoute, context, NotesRoutes.backupScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.delete_forever_outlined,
            ),
            title: Text(
              Languages.of(context).trash,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            selected: _activeRoute == NotesRoutes.trashScreen,
            onTap: () =>
                navigate(_activeRoute, context, NotesRoutes.trashScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
            ),
            title: Text(
              Languages.of(context).settings,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            selected: _activeRoute == NotesRoutes.settingsScreen,
            onTap: () =>
                navigate(_activeRoute, context, NotesRoutes.settingsScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.person_outline,
            ),
            title: Text(
              Languages.of(context).about,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            selected: _activeRoute == NotesRoutes.aboutMeScreen,
            onTap: () =>
                navigate(_activeRoute, context, NotesRoutes.aboutMeScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.email_outlined,
            ),
            title: Text(
              Languages.of(context).reportSuggest,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            selected: _activeRoute == NotesRoutes.suggestScreen,
            onTap: () => goToBugScreen(context),
          ),
        ],
      ),
    );
  }

  String getWish(BuildContext context) {
    final hour = DateTime.now().hour;
    String wish;
    final startWish = Languages.of(context).good;
    var gender = '${Languages.of(context).queen} 👑';
    if (lockChecker.gender == 'men') {
      gender = '${Languages.of(context).king} 👑';
    }
    if (hour >= 5 && hour <= 11) {
      wish = '$startWish ${Languages.of(context).morning}, $gender';
    } else if (hour >= 12 && hour <= 17) {
      wish = '$startWish ${Languages.of(context).afternoon}, $gender';
    } else {
      wish = '$startWish ${Languages.of(context).night}, $gender';
    }
    return wish;
  }
}
