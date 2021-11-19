import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({final Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: settingsList(),
      ),
    );
  }

  Widget settingsList() {
    return SettingsList(
      sections: [
        TilesSection(
          title: Language.of(context).general,
          tiles: [
            SettingsTile(
              title: Language.of(context).labelLanguage,
              leading: const Icon(Icons.language),
              trailing: languageTrailing(),
            ),
            SettingsTile.switchTile(
              title: Language.of(context).directDelete,
              leading: const Icon(Icons.delete_forever_outlined),
              switchActiveColor: Theme.of(context).colorScheme.secondary,
              switchValue: Provider.of<LockChecker>(context, listen: false)
                  .directlyDelete,
              onToggle: directDelete,
            ),
          ],
        ),
        TilesSection(
          title: Language.of(context).ui,
          tiles: [
            SettingsTile(
              trailing: const Icon(Icons.arrow_forward_ios),
              title: Language.of(context).appColor,
              leading: const Icon(
                Icons.color_lens_outlined,
              ),
              onPressed: (final _) {
                colorPicker(
                    'Pick Primary Color',
                    Colors.primaries,
                    Provider.of<AppConfiguration>(context, listen: false)
                        .primaryColor,
                    onPrimaryColorChange);
              },
            ),
            SettingsTile(
              trailing: const Icon(Icons.arrow_forward_ios),
              title: Language.of(context).accentColor,
              leading: const Icon(
                TablerIcons.color_swatch,
              ),
              onPressed: (final _) {
                colorPicker(
                    'Pick Accent Color',
                    Colors.accents,
                    Provider.of<AppConfiguration>(context, listen: false)
                        .accentColor,
                    onAccentColorChange);
              },
            ),
            SettingsTile.switchTile(
              switchActiveColor: Theme.of(context).colorScheme.secondary,
              title: Language.of(context).darkMode,
              leading: const Icon(
                Icons.dark_mode_outlined,
              ),
              switchValue: Provider.of<AppConfiguration>(context, listen: false)
                      .appTheme !=
                  AppTheme.light,
              onToggle: toggleTheme,
            ),
          ],
        ),
        TilesSection(
          title: Language.of(context).security,
          tiles: [
            SettingsTile.switchTile(
              title: Language.of(context).directBio,
              leading: const Icon(
                Icons.fingerprint_outlined,
              ),
              switchActiveColor: Theme.of(context).colorScheme.secondary,
              switchValue:
                  Provider.of<LockChecker>(context, listen: false).fpDirectly,
              onToggle: toggleBiometric,
            ),
            SettingsTile(
              title: Language.of(context).changePassword,
              leading: const Icon(
                Icons.phonelink_lock,
              ),
              onPressed: (final context) {
                onChangePassword();
              },
            ),
            SettingsTile(
              title: Language.of(context).removeBiometric,
              leading: const Icon(
                Icons.face_outlined,
              ),
              onPressed: (final context) {
                onRemoveBioMetric(context);
              },
            ),
            SettingsTile(
              trailing: const Icon(Icons.logout_outlined),
              title: Language.of(context).logOut,
              leading: const Icon(
                TablerIcons.color_swatch,
              ),
              onPressed: logOut,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> colorPicker(final String title, final List<Color> appColors,
      final Color pickerColor, final ValueChanged<Color> onColorChange) async {
    final status = await showDialog(
          barrierDismissible: true,
          context: context,
          builder: (final context) {
            return MyAlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: ColorPicker(
                  availableColors: appColors,
                  pickerColor: pickerColor,
                  onColorChanged: onColorChange,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        ) ??
        false;
    if (status) {}
  }

  void onPrimaryColorChange(final Color value) {
    setState(() {
      Provider.of<AppConfiguration>(context, listen: false).primaryColor =
          value;
    });
    Provider.of<AppConfiguration>(context, listen: false)
        .changePrimaryColor(write: true);
  }

  void onAccentColorChange(final Color value) {
    setState(() {
      Provider.of<AppConfiguration>(context, listen: false).accentColor = value;
    });
    Provider.of<AppConfiguration>(context, listen: false)
        .changeAccentColor(write: true);
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> toggleTheme(final bool value) async {
    setState(
      () {
        if (value) {
          Provider.of<AppConfiguration>(context, listen: false).appTheme =
              AppTheme.black;
        } else {
          Provider.of<AppConfiguration>(context, listen: false).appTheme =
              AppTheme.light;
        }
      },
    );
    Provider.of<AppConfiguration>(context, listen: false)
        .changeAppTheme(write: true);
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> toggleBiometric(final bool value) async {
    setState(() {
      Provider.of<LockChecker>(context, listen: false).fpDirectly = value;
    });
    unawaited(
      addBoolToSF('fpDirectly', value: value),
    );
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> directDelete(final bool deleteDirectly) async {
    setState(() {
      Provider.of<LockChecker>(context, listen: false).directlyDelete =
          deleteDirectly;
    });
    unawaited(
      addBoolToSF('directlyDelete', value: deleteDirectly),
    );
  }

  Future<void> resetPassword() async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (final _) => MyAlertDialog(
        title: Text(Language.of(context).message),
        content: Text(Language.of(context).notAvailJustification),
      ),
    );
  }

  Future<void> onLocaleChange(final LanguageData? value) async {
    // ignore: parameter_assignments
    final locale = await setLocale(value!.languageCode);
    Provider.of<AppConfiguration>(context, listen: false)
        .changeLocale(value.languageCode);
    MyNotes.setLocale(context, locale);
  }

  Future<void> onChangePassword() async {
    if (Provider.of<LockChecker>(context, listen: false).password.isNotEmpty) {
      await Navigator.pushNamed(context, AppRoutes.lockScreen, arguments: true);
    } else {
      await navigate(
        AppRoutes.settingsScreen,
        context,
        AppRoutes.setPassScreen,
        DataObj(
          '',
          'Enter New Password',
          isFirst: true,
        ),
      );
    }
  }

  Future<void> onRemoveBioMetric(final BuildContext context) async {
    final choice = await showDialog<bool>(
          barrierDismissible: true,
          context: context,
          builder: (final context) => MyAlertDialog(
            title: Text(Language.of(context).message),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(Language.of(context).areYouSure),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
                child: Text(Language.of(context).alertDialogOp1),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(false);
                },
                child: Text(Language.of(context).alertDialogOp2),
              ),
            ],
          ),
        ) ??
        false;
    if (choice) {
      await Provider.of<LockChecker>(context, listen: false).resetBio();
      Utilities.showSnackbar(context, Language.of(context).done);
    }
  }

  Widget languageTrailing() {
    return PopupMenuButton(
      icon: Icon(Icons.arrow_drop_down,
          color: Theme.of(context).colorScheme.secondary),
      iconSize: 30,
      onSelected: onLocaleChange,
      itemBuilder: (final _) => supportedLanguages
          .map(
            (final e) => PopupMenuItem(
              value: e,
              child: Text(e.name),
            ),
          )
          .toList(),
    );
  }

  Future<void> logOut(final BuildContext context) async {
    await Provider.of<Auth>(
      context,
      listen: false,
    ).signOut();
    await removeFromSF('syncedWithFirebase');
    await Provider.of<LockChecker>(context, listen: false)
        .resetConfig(shouldResetBio: true);
    unawaited(SqfliteDatabaseHelper.deleteDB());
    await Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.welcomeScreen, (final route) => false);
  }
}
