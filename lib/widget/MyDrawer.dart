import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/app.dart';
import 'package:notes/util/AppRoutes.dart';
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
    final hour = DateTime.now().hour;
    String wish;
    const startWish = 'Good';
    var gender = 'Queen 👑';
    if (myNotes.lockChecker.gender == 'men') {
      gender = 'King 👑';
    } else {}
    if (hour >= 5 && hour <= 11) {
      wish = '$startWish Morning, $gender';
    } else if (hour >= 12 && hour <= 17) {
      wish = '$startWish Afternoon, $gender';
    } else {
      wish = '$startWish Night, $gender';
    }
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(
                'assets/images/${myNotes.lockChecker.gender}.png',
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
            title: const Text(
              'Notes',
            ),
            selected: _activeRoute == NotesRoutes.homeScreen,
            onTap: () =>
                navigate(_activeRoute, context, NotesRoutes.homeScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.archive_outlined,
            ),
            title: const Text('Archive'),
            selected: _activeRoute == NotesRoutes.archiveScreen,
            onTap: () =>
                navigate(_activeRoute, context, NotesRoutes.archiveScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.settings_backup_restore,
            ),
            title: const Text('Backup and Restore'),
            selected: _activeRoute == NotesRoutes.backupScreen,
            onTap: () =>
                navigate(_activeRoute, context, NotesRoutes.backupScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.delete_forever_outlined,
            ),
            title: const Text('Deleted'),
            selected: _activeRoute == NotesRoutes.trashScreen,
            onTap: () =>
                navigate(_activeRoute, context, NotesRoutes.trashScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
            ),
            title: const Text('Settings'),
            selected: _activeRoute == NotesRoutes.settingsScreen,
            onTap: () =>
                navigate(_activeRoute, context, NotesRoutes.settingsScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.person_outline,
            ),
            title: const Text('About Me'),
            selected: _activeRoute == NotesRoutes.aboutMeScreen,
            onTap: () =>
                navigate(_activeRoute, context, NotesRoutes.aboutMeScreen),
          ),
          ListTile(
            leading: const Icon(
              Icons.email_outlined,
            ),
            title: const Text('Report/Suggest'),
            selected: _activeRoute == NotesRoutes.suggestScreen,
            onTap: () => goToBugScreen(context),
          ),
        ],
      ),
    );
  }
}
