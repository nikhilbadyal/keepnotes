import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/model/Languages.dart';
import 'package:notes/screen/lock/BaseLockScreen.dart';
import 'package:notes/screen/lock/SetPassword.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/LockManager.dart';
import 'package:notes/util/Navigations.dart';
import 'package:notes/util/Utilities.dart';
import 'package:notes/widget/AlertDialog.dart';
import 'package:provider/provider.dart';

typedef KeyboardTapCallback = void Function(String text);
typedef DeleteTapCallback = void Function();
typedef FingerTapCallback = void Function();
typedef DoneCallBack = void Function(String text);
typedef DoneEntered = Future<void> Function(String enteredPassCode);

class LockScreen extends StatefulWidget {
  const LockScreen({Key? key}) : super(key: key);

  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String enteredPassCode = '';
  bool args = false;
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  bool isValid = false;

  void onTap(String text) {
    HapticFeedback.vibrate();
    setState(() {
      if (enteredPassCode.length < 4) {
        enteredPassCode += text;
        if (enteredPassCode.length == 4) {
          args
              ? newPassDone(enteredPassCode)
              : doneEnteringPass(enteredPassCode);
        }
      }
    });
  }

  void onDelTap() {
    HapticFeedback.vibrate();
    if (enteredPassCode.isNotEmpty) {
      setState(() {
        enteredPassCode =
            enteredPassCode.substring(0, enteredPassCode.length - 1);
      });
    }
  }

  Future<void> onFingerTap() async {
    await HapticFeedback.vibrate();
    if (Provider.of<LockChecker>(context, listen: false).bioEnabled) {
      if (Provider.of<LockChecker>(context, listen: false).firstTimeNeeded) {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (context) => MyAlertDialog(
            title: Text(Language.of(context).message),
            content: Text(Language.of(context).enterPasswordOnce),
          ),
        );
      } else {
        final status = await Provider.of<LockChecker>(context, listen: false)
            .authenticateUser(context);
        if (status) {
          await navigate(ModalRoute.of(context)!.settings.name!, context,
              AppRoutes.hiddenScreen);
        }
      }
    } else {
      final isAuthenticated = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => MyAlertDialog(
              title: Text(Language.of(context).message),
              content: Text(Language.of(context).setFpFirst),
              actions: [
                TextButton(
                  onPressed: () async {
                    final status =
                        await Provider.of<LockChecker>(context, listen: false)
                            .authenticateFirstTimeUser(context);
                    Navigator.of(context).pop(status);
                  },
                  child: Text(
                    Language.of(context).alertDialogOp1,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    Language.of(context).alertDialogOp2,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ) ??
          false;
      if (isAuthenticated) {
        Utilities.showSnackbar(
          context,
          Language.of(context).done,
        );
        await Provider.of<LockChecker>(context, listen: false)
            .bioEnabledConfig();
      }
    }
  }

  Widget title(BuildContext context) =>
      Text('${Language.of(context).enterPassword} 🙈',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));

  void onPasswordEntered(String data) {
    setState(() {
      enteredPassCode = data;
    });
  }

  Future<void> doneEnteringPass(String enteredPassCode) async {
    if (enteredPassCode ==
        Provider.of<LockChecker>(context, listen: false).password) {
      if (Provider.of<LockChecker>(context, listen: false).bioEnabled &&
          Provider.of<LockChecker>(context, listen: false).firstTimeNeeded) {
        await Utilities.addBoolToSF('firstTimeNeeded', value: false);
        Provider.of<LockChecker>(context, listen: false).firstTimeNeeded =
            false;
      }
      await navigate(ModalRoute.of(context)!.settings.name!, context,
          AppRoutes.hiddenScreen);
    } else {
      _verificationNotifier.add(false);
      // await HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        Utilities.getSnackBar(
          context,
          Language.of(context).wrongPassword,
          action: Utilities.resetAction(context),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments! as bool;
    return MyLockScreen(
      title: title(context),
      onTap: onTap,
      onDelTap: onDelTap,
      onFingerTap: args ? null : onFingerTap,
      enteredPassCode: enteredPassCode,
      stream: _verificationNotifier.stream,
      doneCallBack: onPasswordEntered,
    );
  }

  Future<void> newPassDone(String enteredPassCode) async {
    if (enteredPassCode ==
        Provider.of<LockChecker>(context, listen: false).password) {
      await navigate(
        ModalRoute.of(context)!.settings.name!,
        context,
        AppRoutes.setpassScreen,
        DataObj(
          '',
          Language.of(context).enterNewPassword,
          resetPass: true,
          isFirst: true,
        ),
      );
    } else {
      _verificationNotifier.add(false);
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        Utilities.getSnackBar(
          context,
          Language.of(context).wrongPassword,
          action: Utilities.resetAction(context),
        ),
      );
    }
  }
}
