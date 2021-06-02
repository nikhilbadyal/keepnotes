import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:notes/app.dart';
import 'package:notes/model/Languages.dart';
import 'package:notes/screen/lock/SetPassword.dart';
import 'package:notes/screen/settings/ColorPicker.dart';
import 'package:notes/util/AppConfiguration.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/LockManager.dart';
import 'package:notes/util/Navigations.dart';
import 'package:notes/util/Utilities.dart';
import 'package:notes/widget/AlertDialog.dart';
import 'package:pedantic/pedantic.dart';
import 'package:provider/provider.dart';

class SettingsScreenHelper extends StatefulWidget {
  const SettingsScreenHelper({Key? key}) : super(key: key);

  @override
  _SettingsScreenHelperState createState() => _SettingsScreenHelperState();
}

class _SettingsScreenHelperState extends State<SettingsScreenHelper>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) => body(context);

  Widget body(BuildContext context) => ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          ListTile(
            title: Text(
              Language.of(context).changePassword,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontWeight: FontWeight.w400,
              ),
            ),
            leading: Icon(
              Icons.lock_outline,
              color: Provider.of<AppConfiguration>(context, listen: false)
                  .iconColor,
            ),
            onTap: () async {
              if (Provider.of<LockChecker>(context, listen: false)
                  .password
                  .isNotEmpty) {
                await navigate(
                  ModalRoute.of(context)!.settings.name!,
                  context,
                  AppRoutes.lockScreen,
                  true,
                );
              } else {
                await navigate(
                  ModalRoute.of(context)!.settings.name!,
                  context,
                  AppRoutes.setpassScreen,
                  DataObj(
                    '',
                    'Enter New Password',
                    isFirst: true,
                  ),
                );
              }
            },
          ),
          ListTile(
            title: Text(
              Language.of(context).removeBiometric,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontWeight: FontWeight.w400,
              ),
            ),
            leading: Icon(
              Icons.fingerprint_outlined,
              color: Provider.of<AppConfiguration>(context, listen: false)
                  .iconColor,
            ),
            onTap: () async {
              await Provider.of<LockChecker>(context, listen: false).resetBio();
              Utilities.showSnackbar(context, Language.of(context).done);
            },
          ),
          ListTile(
            title: Text(
              Language.of(context).primaryColor,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontWeight: FontWeight.w400,
              ),
            ),
            leading: Icon(
              Icons.color_lens_outlined,
              color: Provider.of<AppConfiguration>(context, listen: false)
                  .iconColor,
            ),
            onTap: () async {
              await showPrimaryColorPicker();
            },
          ),
          ListTile(
            title: Text(
              Language.of(context).iconColor,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontWeight: FontWeight.w400,
              ),
            ),
            leading: Icon(
              TablerIcons.color_swatch,
              color: Provider.of<AppConfiguration>(context, listen: false)
                  .iconColor,
            ),
            trailing: PopupMenuButton(
              icon: const Icon(Icons.arrow_drop_down),
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
            ),
          ),
          SwitchListTile(
            title: Text(
              Language.of(context).darkMode,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontWeight: FontWeight.w400,
              ),
            ),
            value: Provider.of<AppConfiguration>(context, listen: false)
                    .appTheme !=
                AppTheme.Light,
            onChanged: toggleTheme,
            activeColor:
                Provider.of<AppConfiguration>(context, listen: false).iconColor,
            secondary: Icon(
              Icons.colorize_outlined,
              color: Provider.of<AppConfiguration>(context, listen: false)
                  .iconColor,
            ),
          ),
          SwitchListTile(
            title: Text(
              Language.of(context).directBio,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontWeight: FontWeight.w400,
              ),
            ),
            value: Provider.of<LockChecker>(context, listen: false).fpDirectly,
            onChanged: toggleBiometric,
            activeColor:
                Provider.of<AppConfiguration>(context, listen: false).iconColor,
            secondary: Icon(
              Icons.fingerprint_outlined,
              color: Provider.of<AppConfiguration>(context, listen: false)
                  .iconColor,
            ),
          ),
          SwitchListTile(
            title: Text(
              Language.of(context).directDelete,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontWeight: FontWeight.w400,
              ),
            ),
            value:
                Provider.of<LockChecker>(context, listen: false).directlyDelete,
            onChanged: directDelete,
            activeColor:
                Provider.of<AppConfiguration>(context, listen: false).iconColor,
            secondary: Icon(
              Icons.delete_forever_outlined,
              color: Provider.of<AppConfiguration>(context, listen: false)
                  .iconColor,
            ),
          ),
          ListTile(
            title: Text(
              Language.of(context).labelLanguage,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontWeight: FontWeight.w400),
            ),
            leading: Icon(
              Icons.language_outlined,
              color: Provider.of<AppConfiguration>(context, listen: false)
                  .iconColor,
            ),
            trailing: PopupMenuButton(
              icon: const Icon(Icons.arrow_drop_down),
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
            ),
          ),
        ],
      );

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
                  if (Provider.of<AppConfiguration>(context, listen: false)
                          .iconColorStatus ==
                      IconColorStatus.UiColor) {
                    Provider.of<AppConfiguration>(context, listen: false)
                        .iconColor = value;
                  }
                  Provider.of<AppConfiguration>(context, listen: false)
                      .primaryColor = value;
                  Provider.of<AppConfiguration>(context, listen: false)
                      .changePrimaryColor();
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

  void removeBiometric() {}
}
