import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes/main.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/screen/LockScreen.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/Languages/Languages.dart';
import 'package:notes/util/Navigations.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/widget/DoubleBackToClose.dart';
import 'package:provider/provider.dart';

class SetPassword extends StatefulWidget {
  const SetPassword();

  @override
  _SetPasswordState createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  String enteredPassCode = '';
  late bool isFirst;
  late String firstPass;
  late String title;
  late DataObj args;

  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  void _onTap(String text) {
    setState(() {
      if (isFirst) {
        if (enteredPassCode.length < 4) {
          enteredPassCode += text;
          if (enteredPassCode.length == 4) {
            _doneEnteringPass(enteredPassCode);
          }
        }
      } else {
        if (enteredPassCode.length < firstPass.length) {
          enteredPassCode += text;
          if (enteredPassCode.length == firstPass.length) {
            _doneEnteringPass(enteredPassCode);
          }
        }
      }
    });
  }

  void _onDelTap() {
    if (enteredPassCode.isNotEmpty) {
      setState(() {
        enteredPassCode =
            enteredPassCode.substring(0, enteredPassCode.length - 1);
      });
    }
  }

  Future<void> _doneEnteringPass(String enteredPassCode) async {
    if (isFirst) {
      await navigate(
        ModalRoute.of(context)!.settings.name!,
        context,
        NotesRoutes.setpassScreen,
        DataObj(false, enteredPassCode, Languages.of(context).reEnterPassword,
            resetPass: args.resetPass),
      );
    } else {
      if (enteredPassCode == firstPass) {
        if (args.resetPass) {
          await lockChecker.resetConfig();
          await Provider.of<NotesHelper>(context, listen: false)
              .recryptEverything(enteredPassCode);
          await lockChecker.passwordSetConfig(enteredPassCode);
          await navigate(ModalRoute.of(context)!.settings.name!, context,
              NotesRoutes.homeScreen);
          return;
        } else {
          await lockChecker.passwordSetConfig(enteredPassCode);
          await navigate(ModalRoute.of(context)!.settings.name!, context,
              NotesRoutes.hiddenScreen);
        }
      } else {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          Utilities.getSnackBar(
            context,
            Languages.of(context).passwordNotMatch,
          ),
        );
        await navigate(
          ModalRoute.of(context)!.settings.name!,
          context,
          NotesRoutes.setpassScreen,
          DataObj(
            true,
            '',
            Languages.of(context).enterNewPassword,
          ),
        );
      }
    }
  }

  Widget _titleWidget(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  void validationCheck() {}

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments! as DataObj;
    isFirst = args.isFirst;
    firstPass = args.firstPass;
    title = args.heading;
    final titleWidget = _titleWidget(title);
    return DoubleBackToCloseWidget(
      child: MyLockScreen(
        title: titleWidget,
        onTap: _onTap,
        onDelTap: _onDelTap,
        enteredPassCode: enteredPassCode,
        stream: _verificationNotifier.stream,
        doneCallBack: (_) {},
      ),
    );
  }
}

class DataObj {
  // ignore: avoid_positional_boolean_parameters
  DataObj(this.isFirst, this.firstPass, this.heading, {this.resetPass = false});

  final bool isFirst;
  final String firstPass;
  final String heading;
  final bool resetPass;
}
