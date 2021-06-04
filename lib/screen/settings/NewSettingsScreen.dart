import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:notes/app.dart';
import 'package:notes/model/Languages.dart';
import 'package:notes/screen/lock/SetPassword.dart';
import 'package:notes/screen/settings/ColorPicker.dart';
import 'package:notes/screen/settings/SettingSection.dart';
import 'package:notes/screen/settings/SettingsList.dart';
import 'package:notes/screen/settings/SettingsTiles.dart';
import 'package:notes/util/AppConfiguration.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/LockManager.dart';
import 'package:notes/util/Utilities.dart';
import 'package:notes/widget/AlertDialog.dart';
import 'package:provider/provider.dart';
import 'package:pedantic/pedantic.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SafeArea(
          child: settingsList(),
        ),
      ),
    );
  }

  Widget settingsList() {
    return SettingsList(
      sections: [
        SettingsSection(
          title: Language.of(context).general,
          tiles: [
            SettingsTile(
              title: Language.of(context).labelLanguage,
              leading: Icon(Icons.language,
                  color: Provider.of<AppConfiguration>(context, listen: false)
                      .iconColor),
              trailing: languageTrailing(),
            ),
            SettingsTile.switchTile(
              title: Language.of(context).directDelete,
              switchActiveColor: Theme.of(context).accentColor,
              leading: Icon(Icons.delete_forever_outlined,
                  color: Provider.of<AppConfiguration>(context, listen: false)
                      .iconColor),
              switchValue: Provider.of<LockChecker>(context, listen: false)
                  .directlyDelete,
              onToggle: directDelete,
            ),
          ],
        ),
        SettingsSection(
          title: Language.of(context).ui,
          tiles: [
            SettingsTile(
              title: Language.of(context).appColor,
              leading: Icon(
                Icons.color_lens_outlined,
                color: Provider.of<AppConfiguration>(context, listen: false)
                    .iconColor,
              ),
              onPressed: (context) {
                showPrimaryColorPicker();
              },
            ),
            SettingsTile(
              title: Language.of(context).iconColor,
              leading: Icon(
                TablerIcons.color_swatch,
                color: Provider.of<AppConfiguration>(context, listen: false)
                    .iconColor,
              ),
              trailing: iconColorTrailing(),
            ),
            SettingsTile.switchTile(
              switchActiveColor: Theme.of(context).accentColor,
              title: Language.of(context).darkMode,
              leading: Icon(Icons.dark_mode_outlined,
                  color: Provider.of<AppConfiguration>(context, listen: false)
                      .iconColor),
              switchValue: Provider.of<AppConfiguration>(context, listen: false)
                      .appTheme !=
                  AppTheme.Light,
              onToggle: toggleTheme,
            ),
          ],
        ),
        SettingsSection(
          title: Language.of(context).security,
          tiles: [
            SettingsTile(
              title: Language.of(context).changePassword,
              leading: Icon(Icons.phonelink_lock,
                  color: Provider.of<AppConfiguration>(context, listen: false)
                      .iconColor),
              onPressed: (context) {
                onChangePassword();
              },
            ),
            SettingsTile(
              title: Language.of(context).removeBiometric,
              leading: Icon(Icons.face_outlined,
                  color: Provider.of<AppConfiguration>(context, listen: false)
                      .iconColor),
              onPressed: (context) {
                onRemoveBioMetric(context);
              },
            ),
            SettingsTile.switchTile(
              title: Language.of(context).directBio,
              leading: Icon(Icons.fingerprint_outlined,
                  color: Provider.of<AppConfiguration>(context, listen: false)
                      .iconColor),
              switchActiveColor: Theme.of(context).accentColor,
              switchValue:
                  Provider.of<LockChecker>(context, listen: false).fpDirectly,
              onToggle: toggleBiometric,
            ),
          ],
        ),
      ],
    );
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> toggleTheme(bool value) async {
    setState(
      () {
        if (value) {
          Provider.of<AppConfiguration>(context, listen: false).appTheme =
              AppTheme.Black;
        } else {
          Provider.of<AppConfiguration>(context, listen: false).appTheme =
              AppTheme.Light;
        }
      },
    );
    Provider.of<AppConfiguration>(context, listen: false)
        .changeAppTheme(write: true);
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> toggleBiometric(bool value) async {
    setState(() {
      Provider.of<LockChecker>(context, listen: false).fpDirectly = value;
    });
    unawaited(
      Utilities.addBoolToSF('fpDirectly', value: value),
    );
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> directDelete(bool deleteDirectly) async {
    setState(() {
      Provider.of<LockChecker>(context, listen: false).directlyDelete =
          deleteDirectly;
    });
    unawaited(
      Utilities.addBoolToSF('directlyDelete', value: deleteDirectly),
    );
  }

  Future<void> showPrimaryColorPicker() async {
    final initAppColor =
        Provider.of<AppConfiguration>(context, listen: false).primaryColor;
    final initIconColor =
        Provider.of<AppConfiguration>(context, listen: false).iconColor;

    final status = await showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => MyAlertDialog(
            title: Text(Language.of(context).pickColor),
            content: SingleChildScrollView(
              child: ColorPicker(
                availableColors: appColors,
                pickerColor:
                    Provider.of<AppConfiguration>(context).primaryColor,
                onColorChanged: (value) async {
                  setState(() {
                    if (Provider.of<AppConfiguration>(context, listen: false)
                            .iconColorStatus ==
                        IconColorStatus.UiColor) {
                      debugPrint('change icon color');
                      Provider.of<AppConfiguration>(context, listen: false)
                          .iconColor = value;
                    }
                    Provider.of<AppConfiguration>(context, listen: false)
                        .primaryColor = value;
                    Provider.of<AppConfiguration>(context, listen: false)
                        .changePrimaryColor();
                  });
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(Language.of(context).done),
              ),
            ],
          ),
        ) ??
        false;
    if (status) {
      Provider.of<AppConfiguration>(context, listen: false)
          .changePrimaryColor(write: true);
    } else {
      Provider.of<AppConfiguration>(context, listen: false).iconColor =
          initIconColor;
      Provider.of<AppConfiguration>(context, listen: false).primaryColor =
          initAppColor;
      Provider.of<AppConfiguration>(context, listen: false)
          .changePrimaryColor();
    }
  }

  Future<void> showIconColorPicker() async {
    final initColor =
        Provider.of<AppConfiguration>(context, listen: false).iconColor;
    final status = await showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => MyAlertDialog(
            title: Text(Language.of(context).pickColor),
            content: SingleChildScrollView(
              child: ColorPicker(
                availableColors: appColors,
                pickerColor:
                    Provider.of<AppConfiguration>(context, listen: false)
                        .iconColor,
                onColorChanged: (value) {
                  setState(() {
                    Provider.of<AppConfiguration>(context, listen: false)
                        .iconColor = value;
                  });
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
                child: Text(Language.of(context).done),
              ),
            ],
          ),
        ) ??
        false;
    if (status) {
      Provider.of<AppConfiguration>(context, listen: false).changeIconColor();
    } else {
      setState(() {
        Provider.of<AppConfiguration>(context, listen: false).iconColor =
            initColor;
      });
    }
  }

  Future<void> resetPassword() async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) => MyAlertDialog(
        title: Text(Language.of(context).message),
        content: Text(Language.of(context).notAvailJustification),
      ),
    );
  }

  Future<void> onLocaleChange(LanguageData? value) async {
    // ignore: parameter_assignments
    final locale = await setLocale(value!.languageCode);
    Provider.of<AppConfiguration>(context, listen: false)
        .changeLocale(value.languageCode);
    MyNotes.setLocale(context, locale);
  }

  void onIconColorChange(IconColorStatus status) {
    if (status == IconColorStatus.PickedColor) {
      showIconColorPicker();
    } else if (status == IconColorStatus.UiColor) {
      Provider.of<AppConfiguration>(context, listen: false).iconColor =
          Provider.of<AppConfiguration>(context, listen: false).primaryColor;
    } else {
      Provider.of<AppConfiguration>(context, listen: false).iconColor =
          Provider.of<AppConfiguration>(context, listen: false).appTheme ==
                  AppTheme.Light
              ? Colors.black
              : Colors.white;
    }
    Provider.of<AppConfiguration>(context, listen: false)
        .changeIconColorStatus(status.index);
    setState(() {
      Provider.of<AppConfiguration>(context, listen: false).iconColorStatus =
          status;
    });
  }

  Future<void> onChangePassword() async {
    if (Provider.of<LockChecker>(context, listen: false).password.isNotEmpty) {
      await Navigator.pushNamed(context, AppRoutes.lockScreen, arguments: true);
    } else {
      await Navigator.pushNamed(
        context,
        AppRoutes.setPassScreen,
        arguments: DataObj(
          '',
          'Enter New Password',
          isFirst: true,
        ),
      );
    }
  }

  Future<void> onRemoveBioMetric(BuildContext context) async {
    final choice = await showDialog<bool>(
          barrierDismissible: true,
          context: context,
          builder: (context) => MyAlertDialog(
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
      icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).accentColor),
      iconSize: 30,
      onSelected: onLocaleChange,
      itemBuilder: (_) => supportedLanguages
          .map(
            (e) => PopupMenuItem(
              value: e,
              child: Text(e.name),
            ),
          )
          .toList(),
    );
  }

  Widget iconColorTrailing() {
    return PopupMenuButton(
      icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).accentColor),
      iconSize: 30,
      onSelected: onIconColorChange,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: IconColorStatus.NoColor,
          child: Text(Language.of(context).noColor),
        ),
        PopupMenuItem(
          value: IconColorStatus.PickedColor,
          child: Text(Language.of(context).pickColor),
        ),
        PopupMenuItem(
          value: IconColorStatus.UiColor,
          child: Text(Language.of(context).appColor),
        ),
      ],
    );
  }
}
