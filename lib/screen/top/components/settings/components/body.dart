import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';
import 'package:notes/widget/color_picker.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    final Key? key,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var directlyDelete = true;
  var fpDirectly = true;
  var primaryColor = defaultPrimary;
  var accentColor = defaultAccent;
  var appTheme = AppTheme.black;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    directlyDelete = getBoolFromSF('directlyDelete') ?? true;
    fpDirectly = getBoolFromSF('fpDirectly') ?? true;
    primaryColor = Color(getIntFromSF('primaryColor') ?? defaultPrimary.value);
    accentColor = Color(getIntFromSF('accentColor') ?? defaultAccent.value);
    appTheme =
        AppTheme.values[getIntFromSF('appTheme') ?? AppTheme.black.index];
    setState(() {});
  }

  @override
  Widget build(final BuildContext context) {
    return settingsList();
  }

  Widget settingsList() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SettingsList(
        sections: [
          TilesSection(
            title: context.language.general,
            tiles: [
              SettingsTile(
                title: context.language.labelLanguage,
                leading: const Icon(Icons.language),
                trailing: languageTrailing(),
              ),
              SettingsTile.switchTile(
                title: context.language.directDelete,
                leading: const Icon(Icons.delete_forever_outlined),
                activeText: context.language.on,
                inactiveText: context.language.off,
                switchActiveColor: context.secondaryColor,
                switchValue: directlyDelete,
                onToggle: directDelete,
              ),
            ],
          ),
          TilesSection(
            title: context.language.ui,
            tiles: [
              SettingsTile(
                trailing: const Icon(Icons.arrow_forward_ios),
                title: context.language.appColor,
                leading: const Icon(
                  Icons.color_lens_outlined,
                ),
                onPressed: (final context) {
                  colorPicker(
                    context.language.pickColor,
                    primaryColors,
                    primaryColor,
                    onPrimaryColorChange,
                  );
                },
              ),
              SettingsTile(
                trailing: const Icon(Icons.arrow_forward_ios),
                title: context.language.accentColor,
                leading: const Icon(
                  TablerIcons.color_swatch,
                ),
                onPressed: (final context) {
                  colorPicker(
                    context.language.pickColor,
                    secondaryColors,
                    accentColor,
                    onAccentColorChange,
                  );
                },
              ),
              SettingsTile.switchTile(
                switchActiveColor: context.secondaryColor,
                title: context.language.darkMode,
                activeText: context.language.on,
                inactiveText: context.language.off,
                leading: const Icon(
                  Icons.dark_mode_outlined,
                ),
                switchValue: appTheme != AppTheme.light,
                onToggle: toggleTheme,
              ),
            ],
          ),
          TilesSection(
            title: context.language.security,
            tiles: [
              SettingsTile.switchTile(
                title: context.language.directBio,
                activeText: context.language.on,
                inactiveText: context.language.off,
                leading: const Icon(
                  Icons.fingerprint_outlined,
                ),
                switchActiveColor: context.secondaryColor,
                switchValue: fpDirectly,
                onToggle: toggleBiometric,
              ),
              SettingsTile(
                title: context.language.importNotes,
                leading: const Icon(Icons.notes_outlined),
                onPressed: (final context) {
                  importFromFile().then((final value) {
                    showSnackbar(
                      context,
                      value ? context.language.done : context.language.error,
                      snackBarBehavior: SnackBarBehavior.floating,
                    );
                  });
                },
              ),
              SettingsTile(
                title: context.language.exportNotes,
                leading: const Icon(Icons.cloud_outlined),
                onPressed: (final context) {
                  showDialog(
                    context: context,
                    builder: (final context) {
                      return AlertDialog(
                        content: Text(
                          context.language.backupWarning,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              if (context
                                  .read<AppConfiguration>()
                                  .password
                                  .isNotEmpty) {
                                context.nextReplacementPage(
                                  AppRoutes.lockScreen,
                                  arguments: false,
                                );
                              } else {
                                showSnackbar(
                                  context,
                                  context.language.setPasswordFirst,
                                );
                              }
                            },
                            child: Text(
                              context.language.alertDialogOp1,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              exportToFile().then((final value) {
                                showSnackbar(
                                  context,
                                  value
                                      ? context.language.done
                                      : context.language.error,
                                  snackBarBehavior: SnackBarBehavior.floating,
                                );
                              });
                              context.previousPage();
                            },
                            child: Text(
                              context.language.alreadyDone,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              SettingsTile(
                title: context.language.changePassword,
                leading: const Icon(
                  Icons.phonelink_lock,
                ),
                onPressed: (final context) {
                  onChangePassword();
                },
              ),
              SettingsTile(
                title: context.language.removeBiometric,
                leading: const Icon(
                  Icons.face_outlined,
                ),
                onPressed: (final context) {
                  onRemoveBioMetric(context);
                },
              ),
              SettingsTile(
                title: context.language.logOut,
                leading: const Icon(
                  TablerIcons.logout,
                ),
                onPressed: logOut,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> colorPicker(
    final String title,
    final List<Color> appColors,
    final Color pickerColor,
    final ValueChanged<Color> onColorChange,
  ) async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (final context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: BlockPicker(
              availableColors: appColors,
              pickerColor: pickerColor,
              onColorChanged: onColorChange,
            ),
          ),
        );
      },
    );
  }

  void onPrimaryColorChange(final Color value) {
    primaryColor = value;
    context.appConfig.changePrimaryColor(primaryColor);
  }

  void onAccentColorChange(final Color value) {
    accentColor = value;
    context.appConfig.changeAccentColor(accentColor);
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> toggleTheme(final bool value) async {
    if (value) {
      appTheme = AppTheme.black;
    } else {
      appTheme = AppTheme.light;
    }
    context.appConfig.changeAppTheme(appTheme);
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> toggleBiometric(final bool value) async {
    fpDirectly = value;
    unawaited(
      addBoolToSF('fpDirectly', value: value),
    );
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> directDelete(final bool deleteDirectly) async {
    directlyDelete = deleteDirectly;
    unawaited(
      addBoolToSF('directlyDelete', value: deleteDirectly),
    );
  }

  Future<void> resetPassword() async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (final context) => MyAlertDialog(
        content: Text(
          context.language.notAvailJustification,
        ),
      ),
    );
  }

  Future<void> onLocaleChange(final LanguageData? value) async {
    if (value == null) {
      return;
    }
    final locale = setLocale(value.languageCode);
    context.read<AppConfiguration>().changeLocale(value.languageCode);
    MyNotes.setLocale(context, locale);
  }

  Future<void> onChangePassword() async {
    if (context.appConfig.password.isNotEmpty) {
      context.nextPage(AppRoutes.lockScreen, arguments: true);
    } else {
      showSnackbar(
        context,
        context.language.setPasswordFirst,
      );
    }
  }

  Future<void> onRemoveBioMetric(final BuildContext context) async {
    final choice = await showDialog<bool>(
          barrierDismissible: true,
          context: context,
          builder: (final context) => MyAlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    context.language.areYouSure,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => context.previousPage(true),
                child: Text(
                  context.language.alertDialogOp1,
                ),
              ),
              TextButton(
                onPressed: () => context.previousPage(false),
                child: Text(
                  context.language.alertDialogOp2,
                ),
              ),
            ],
          ),
        ) ??
        false;
    if (!mounted) {
      return;
    }

    if (choice) {
      await context.appConfig.resetBio();
      if (!mounted) {
        return;
      }

      showSnackbar(
        context,
        context.language.done,
      );
    }
  }

  Widget languageTrailing() {
    return PopupMenuButton(
      color: context.theme.scaffoldBackgroundColor,
      icon: Icon(
        Icons.arrow_drop_down,
        color: context.secondaryColor,
      ),
      iconSize: 30,
      onSelected: onLocaleChange,
      itemBuilder: (final context) => supportedLanguages
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
    await context.firebaseAuth.signOut();
    if (!mounted) {
      return;
    }

    await context.noteHelper.signOut();
    if (!mounted) {
      return;
    }

    await context.appConfig.resetConfig();
    if (!mounted) {
      return;
    }

    await Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.introScreen,
      (final route) => false,
    );
  }
}
