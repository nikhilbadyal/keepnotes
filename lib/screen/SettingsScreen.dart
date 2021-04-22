import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:notes/app.dart';
import 'package:notes/main.dart';
import 'package:notes/screen/SetPassword.dart';
import 'package:notes/util/AppConfiguration.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/ColorPicker.dart';
import 'package:notes/util/Languages/Languages.dart';
import 'package:notes/util/Navigations.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/widget/AlertDialog.dart';
import 'package:pedantic/pedantic.dart';
import 'package:provider/provider.dart';

class SettingsScreenHelper extends StatefulWidget {
  const SettingsScreenHelper();

  @override
  _SettingsScreenHelperState createState() {
    return _SettingsScreenHelperState();
  }
}

class _SettingsScreenHelperState extends State<SettingsScreenHelper>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return body(context);
  }

  Widget body(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        ListTile(
          title: Text(
            Languages.of(context).changePassword,
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontWeight: FontWeight.w500),
          ),
          leading: Icon(
            Icons.lock_outline,
            color: Utilities.iconColor(),
          ),
          onTap: () async {
            if (lockChecker.passwordSet) {
              await navigate(
                ModalRoute.of(context)!.settings.name!,
                context,
                NotesRoutes.lockScreen,
                true,
              );
            } else {
              await navigate(
                ModalRoute.of(context)!.settings.name!,
                context,
                NotesRoutes.setpassScreen,
                DataObj(
                  true,
                  '',
                  'Enter New Password',
                ),
              );
            }
          },
        ),
        ListTile(
          title: Text(
            Languages.of(context).resetPassword,
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontWeight: FontWeight.w500),
          ),
          leading: Icon(
            Icons.lock_open,
            color: Utilities.iconColor(),
          ),
          onTap: resetPassword,
        ),
        ListTile(
          title: Text(
            Languages.of(context).primaryColor,
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontWeight: FontWeight.w500),
          ),
          leading: Icon(
            Icons.color_lens_outlined,
            color: Utilities.iconColor(),
          ),
          onTap: () async {
            await showPrimaryColorPicker();
          },
        ),
        ListTile(
          title: Text(
            Languages.of(context).iconColor,
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontWeight: FontWeight.w500),
          ),
          leading: Icon(
            TablerIcons.color_swatch,
            color: Utilities.iconColor(),
          ),
          trailing: PopupMenuButton(
            // icon: const Icon(Icons.colorize_outlined),
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 30,
            onSelected: (result) {
              if (result == IconColorStatus.PickedColor) {
                showIconColorPicker();
              } else {
                Provider.of<AppConfiguration>(context, listen: false)
                    .changeIconColor(result! as IconColorStatus);
              }
              setState(() {
                selectedIconColorStatus = result! as IconColorStatus;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: IconColorStatus.NoColor,
                child: Text(Languages.of(context).noColor),
              ),
              PopupMenuItem(
                value: IconColorStatus.RandomColor,
                child: Text(Languages.of(context).randomColor),
              ),
              PopupMenuItem(
                value: IconColorStatus.PickedColor,
                child: Text(Languages.of(context).pickColor),
              ),
              PopupMenuItem(
                value: IconColorStatus.UiColor,
                child: Text(Languages.of(context).appColor),
              ),
            ],
          ),
        ),
        SwitchListTile(
          title: Text(
            Languages.of(context).darkMode,
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontWeight: FontWeight.w500),
          ),
          value: selectedAppTheme != AppTheme.Light,
          onChanged: toggleTheme,
          activeColor: Utilities.iconColor(),
          secondary: Icon(
            Icons.colorize_outlined,
            color: Utilities.iconColor(),
          ),
        ),
        SwitchListTile(
          title: Text(
            Languages.of(context).directBio,
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontWeight: FontWeight.w500),
          ),
          value: lockChecker.fpDirectly,
          onChanged: toggleBiometric,
          activeColor: Utilities.iconColor(),
          secondary: Icon(
            Icons.fingerprint_outlined,
            color: Utilities.iconColor(),
          ),
        ),
        SwitchListTile(
          title: Text(
            Languages.of(context).directDelete,
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontWeight: FontWeight.w500),
          ),
          value: lockChecker.directlyDelete,
          onChanged: directDelete,
          activeColor: Utilities.iconColor(),
          secondary: Icon(
            Icons.delete_forever_outlined,
            color: Utilities.iconColor(),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.language_outlined,
            color: Utilities.iconColor(),
          ),
          title: Text(
            Languages.of(context).labelLanguage,
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontWeight: FontWeight.w500),
          ),
          trailing: Container(
            color: Colors.transparent,
            child: DropdownButton<LanguageData>(
              iconSize: 30,
              onChanged: onLocaleChange,
              underline: DropdownButtonHideUnderline(child: Container()),
              items: supportedLanguages
                  .map<DropdownMenuItem<LanguageData>>(
                    (e) => DropdownMenuItem<LanguageData>(
                      value: e,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            e.name,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color),
                          )
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> showPrimaryColorPicker() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        selectedPrimaryColor =
            Provider.of<AppConfiguration>(context).primaryColor;
        return MyAlertDialog(
          title: Text(Languages.of(context).pickColor),
          content: SingleChildScrollView(
            child: ColorPicker(
              availableColors: appColors,
              pickerColor: selectedPrimaryColor,
              onColorChanged: (Color value) async {
                if (selectedIconColorStatus == IconColorStatus.UiColor) {
                  setState(() {
                    selectedIconColor = value;
                  });
                }
                selectedPrimaryColor = value;
                Provider.of<AppConfiguration>(context, listen: false)
                    .changePrimaryColor(selectedPrimaryColor);
                await Future.delayed(
                  const Duration(seconds: 1),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Provider.of<AppConfiguration>(context, listen: false)
                    .changePrimaryColor(selectedPrimaryColor, write: true);
                Navigator.of(context).pop();
              },
              child: Text(Languages.of(context).done),
            ),
          ],
        );
      },
    );
  }

  Future<void> showIconColorPicker() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyAlertDialog(
          title: Text(Languages.of(context).pickColor),
          content: SingleChildScrollView(
            child: ColorPicker(
              availableColors: appColors,
              pickerColor: selectedIconColor,
              onColorChanged: (Color value) {
                setState(() {
                  selectedIconColor = value;
                });
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Provider.of<AppConfiguration>(context, listen: false)
                    .changeIconColor(IconColorStatus.PickedColor,
                        pickedColor: selectedIconColor);
                Navigator.of(context).pop();
              },
              child: Text(Languages.of(context).done),
            ),
          ],
        );
      },
    );
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> toggleTheme(bool value) async {
    setState(() {
      if (value) {
        selectedAppTheme = AppTheme.Black;
      } else {
        selectedAppTheme = AppTheme.Light;
      }
    });
    Provider.of<AppConfiguration>(context, listen: false).changeAppThemeColor(
        value ? AppTheme.Black : AppTheme.Light,
        write: true);
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> toggleBiometric(bool value) async {
    setState(() {
      lockChecker.fpDirectly = value;
    });
    unawaited(
      Utilities.addBoolToSF('fpDirectly', value: value),
    );
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> directDelete(bool value) async {
    setState(() {
      lockChecker.directlyDelete = value;
    });
    unawaited(
      Utilities.addBoolToSF('directlyDelete', value: value),
    );
  }

  Future<void> resetPassword() async {
    await showDialog(
        context: context,
        builder: (_) {
          return MyAlertDialog(
            title: Text(Languages.of(context).message),
            content: Text(Languages.of(context).notAvailJustification),
          );
        });
  }

  Future<void> onLocaleChange(LanguageData? value) async {
    // ignore: parameter_assignments
    value ??= LanguageData('us', 'English', 'en');
    final locale = await setLocale(value.languageCode);
    Provider.of<AppConfiguration>(context, listen: false)
        .changeLocale(value.languageCode);
    MyNotes.setLocale(context, locale);
  }
}
