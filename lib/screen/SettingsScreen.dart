import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:notes/app.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/screen/SetPassword.dart';
import 'package:notes/util/AppConfiguration.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/Navigations.dart';
import 'package:notes/util/Utilites.dart';
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
    //debugPrint('building 11');
    return body(context);
  }

  Widget body(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        ListTile(
          title: const Text(
            'Change Password',
          ),
          leading: Icon(
            Icons.lock_outline,
            color: Utilities.iconColor(),
          ),
          onTap: () async {
            if (myNotes.lockChecker.passwordSet) {
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
          title: const Text(
            'Reset Password',
          ),
          leading: Icon(
            Icons.lock_open,
            color: Utilities.iconColor(),
          ),
          onTap: resetPassword,
        ),
        ListTile(
          title: const Text(
            'PrimaryColor',
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
          title: const Text(
            'Icon Color',
          ),
          leading: Icon(
            TablerIcons.color_swatch,
            color: Utilities.iconColor(),
          ),
          trailing: PopupMenuButton(
            icon: const Icon(Icons.colorize_outlined),
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
              const PopupMenuItem(
                value: IconColorStatus.NoColor,
                child: Text('No Color'),
              ),
              const PopupMenuItem(
                value: IconColorStatus.RandomColor,
                child: Text('Random Color'),
              ),
              const PopupMenuItem(
                value: IconColorStatus.PickedColor,
                child: Text('Pick Color'),
              ),
              const PopupMenuItem(
                value: IconColorStatus.UiColor,
                child: Text('App Color'),
              ),
            ],
          ),
        ),
        SwitchListTile(
          title: const Text('Dark Mode'),
          value: selectedAppTheme != AppTheme.Light,
          onChanged: toggleTheme,
          activeColor: Utilities.iconColor(),
          secondary: Icon(
            Icons.colorize_outlined,
            color: Utilities.iconColor(),
          ),
        ),
        SwitchListTile(
          title: const Text('Directly ask for Biometric'),
          value: myNotes.lockChecker.fpDirectly,
          onChanged: toggleBiometric,
          activeColor: Utilities.iconColor(),
          secondary: Icon(
            Icons.fingerprint_outlined,
            color: Utilities.iconColor(),
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
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: BlockPicker(
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
              child: const Text('Done'),
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
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: BlockPicker(
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
              child: const Text('Done'),
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
    await Future.delayed(
      const Duration(seconds: 1),
    );
    final _systemBrightness = Theme.of(context).brightness;
    final _statusBarBrightness = _systemBrightness == Brightness.light
        ? Brightness.dark
        : Brightness.light;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: _statusBarBrightness,
        statusBarIconBrightness: _statusBarBrightness,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: _statusBarBrightness,
      ),
    );
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> toggleBiometric(bool value) async {
    setState(() {
      myNotes.lockChecker.fpDirectly = value;
    });
    unawaited(Utilities.addBoolToSF('fpDirectly', value: value));
  }

  Future<void> resetPassword() async {
    await showDialog(
        context: context,
        builder: (_) {
          return const MyAlertDialog(
              title: Center(child: Text('Not Available yet')),
              content: Padding(
                padding: EdgeInsets.only(left: 36.0, top: 16.0, bottom: 16.0),
                child: Text('May be in next update'),
              ));
        });
  }
}
