import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes/model/Languages.dart';
import 'package:notes/screen/lock/Keyboard.dart';
import 'package:notes/screen/lock/SetPassword.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/LockManager.dart';
import 'package:notes/util/Navigations.dart';
import 'package:notes/util/Utilities.dart';
import 'package:notes/widget/AlertDialog.dart';
import 'package:notes/widget/DoubleBackToClose.dart';
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
    if (enteredPassCode.isNotEmpty) {
      setState(() {
        enteredPassCode =
            enteredPassCode.substring(0, enteredPassCode.length - 1);
      });
    }
  }

  Future<void> onFingerTap() async {
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
          'User Registered',
        );
        await Provider.of<LockChecker>(context, listen: false)
            .bioEnabledConfig();
      }
    }
  }

  Widget title(BuildContext context) => Text(Language.of(context).enterPassword,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));

  void callSetState(String data) {
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
      doneCallBack: callSetState,
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

class MyLockScreen extends StatefulWidget {
  const MyLockScreen({
    required this.title,
    required this.onTap,
    required this.onDelTap,
    required this.enteredPassCode,
    required this.stream,
    required this.doneCallBack,
    this.onFingerTap,
    Key? key,
  }) : super(key: key);

  final Widget title;
  final KeyboardTapCallback onTap;
  final DeleteTapCallback onDelTap;
  final FingerTapCallback? onFingerTap;
  final String enteredPassCode;
  final Stream<bool> stream;
  final DoneCallBack doneCallBack;

  @override
  _MyLockScreenState createState() => _MyLockScreenState();
}

class _MyLockScreenState extends State<MyLockScreen>
    with SingleTickerProviderStateMixin {
  late StreamSubscription<bool> streamSubscription;
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void dispose() {
    super.dispose();
    streamSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    streamSubscription = widget.stream.listen(
      (isValid) => _showValidation(isValid),
    );
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    final Animation<double> curve = CurvedAnimation(
      parent: controller,
      curve: ShakeCurve(),
    );
    // ignore: prefer_int_literals
    animation = Tween(begin: 0.0, end: 10.0).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            widget.doneCallBack('');
            controller.value = 0;
          });
        }
      })
      ..addListener(() {
        // setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) => DoubleBackToCloseWidget(
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: _buildCancelButton(context),
                          ),
                          widget.title,
                          const SizedBox(
                            height: 50,
                          ),
                          SizedBox(
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _buildCircles(widget.enteredPassCode),
                            ),
                          ),
                          _buildKeyBoard(widget.onTap, widget.onDelTap,
                              widget.onFingerTap, widget.enteredPassCode),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  void _showValidation(bool isValid) {
    if (!isValid) {
      controller.forward();
    }
  }

  List<Widget> _buildCircles(String enteredPassCode) {
    final list = <Widget>[];
    final size = animation.value;
    for (var i = 0; i < 4; ++i) {
      list.add(
        Container(
          margin: const EdgeInsets.all(8),
          child: Circle(
            isFilled: i < enteredPassCode.length,
            size: size,
          ),
        ),
      );
    }
    return list;
  }
}

Widget _buildKeyBoard(KeyboardTapCallback _onTap, DeleteTapCallback onDelTap,
        FingerTapCallback? onFingerTap, String enteredPassCode) =>
    Keyboard(
      onKeyboardTap: _onTap,
      onDelTap: onDelTap,
      onFingerTap: onFingerTap,
    );

Widget _buildCancelButton(BuildContext context) => Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.cancel,
            size: 25,
          ),
          onPressed: () async {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            await Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (route) => false);
          },
        ),
      ],
    );
