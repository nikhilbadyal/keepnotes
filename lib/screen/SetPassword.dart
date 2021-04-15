import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes/app.dart';
import 'package:notes/screen/LockScreen.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/Navigations.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/widget/DoubleBackToClose.dart';

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
        DataObj(false, enteredPassCode, 'Re Enter Password'),
      );
    } else {
      if (enteredPassCode == firstPass) {
        await myNotes.lockChecker.passwordSetConfig(enteredPassCode);
        await navigate(ModalRoute.of(context)!.settings.name!, context,
            NotesRoutes.hiddenScreen);
      } else {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          Utilities.getSnackBar(
            context,
            "PassCodes doesn't match",
          ),
        );
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
    //debugPrint('building 28 ');
    final args = ModalRoute.of(context)!.settings.arguments! as DataObj;
    isFirst = args.isFirst;
    firstPass = args.firstPass;
    title = args.heading;
    final titleWidget = _titleWidget(title);
    // debugPrint('set pass');
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
  DataObj(this.isFirst, this.firstPass, this.heading);

  final bool isFirst;
  final String firstPass;
  final String heading;
}
