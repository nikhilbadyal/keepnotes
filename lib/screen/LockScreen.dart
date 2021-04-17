import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes/app.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/util/AppConfiguration.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/Navigations.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/widget/DoubleBackToClose.dart';

typedef KeyboardTapCallback = void Function(String text);
typedef DeleteTapCallback = void Function();
typedef FingerTapCallback = void Function();
typedef DoneCallBack = void Function(String text);

const String pass = '1234';

class LockScreen extends StatefulWidget {
  const LockScreen();

  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String enteredPassCode = '';
  var args = false;
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  bool isValid = false;

  void onTap(String text) {
    setState(() {
      if (enteredPassCode.length < pass.length) {
        enteredPassCode += text;
        if (enteredPassCode.length == pass.length) {
          doneEnteringPass(enteredPassCode);
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
    if (myNotes.lockChecker.bioEnabled) {
      if (myNotes.lockChecker.firstTimeNeeded) {
        await showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return const MySimpleDialog(
              title: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Please enter password at least once'),
              ),
            );
          },
        );
      } else {
        final status = await myNotes.lockChecker.authenticateUser(context);
        if (status) {
          await navigate(ModalRoute.of(context)!.settings.name!, context,
              NotesRoutes.hiddenScreen);
        }
      }
    } else {
      await showDialog<bool>(
        context: context,
        builder: (context) => MyAlertDialog(
          // : const Text('Fingerprint '),
          title: const Text('Message'),
          content: const Text('Set Fingerprint First'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true);
                await myNotes.lockChecker.authenticateFirstTimeUser(context);
                // TODO fix this .2
                /*if (status) {
                  Utilities.showSnackbar(
                    context,
                    'User Registered',
                  );
                }*/
              },
              child: const Text(
                'Sure',
                style: TextStyle(fontSize: 20),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text(
                'Later',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget title = const Text(
    'Enter Password',
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  );

  void callSetState(String data) {
    setState(() {
      enteredPassCode = data;
    });
  }

  Future<void> doneEnteringPass(String enteredPassCode) async {
    if (enteredPassCode == myNotes.lockChecker.password) {
      if (myNotes.lockChecker.bioEnabled &&
          myNotes.lockChecker.firstTimeNeeded) {
        await Utilities.addBoolToSF('firstTimeNeeded', value: false);
        myNotes.lockChecker.firstTimeNeeded = false;
      }
      if (args) {
        await Utilities.resetPassword(context);
        return;
      }
      await navigate(ModalRoute.of(context)!.settings.name!, context,
          NotesRoutes.hiddenScreen);
    } else {
      _verificationNotifier.add(false);
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        Utilities.getSnackBar(
          context,
          'Wrong Passcode',
          action: Utilities.resetAction(context),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint('building 23');
    args = ModalRoute.of(context)!.settings.arguments! as bool;
    return MyLockScreen(
      title: title,
      onTap: onTap,
      onDelTap: onDelTap,
      onFingerTap: args ? null : onFingerTap,
      enteredPassCode: enteredPassCode,
      stream: _verificationNotifier.stream,
      doneCallBack: callSetState,
    );
  }
}

class MyLockScreen extends StatefulWidget {
  const MyLockScreen({
    Key? key,
    required this.title,
    required this.onTap,
    required this.onDelTap,
    this.onFingerTap,
    required this.enteredPassCode,
    required this.stream,
    required this.doneCallBack,
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
        duration: const Duration(milliseconds: 400), vsync: this);
    final Animation<double> curve = CurvedAnimation(
      parent: controller,
      curve: ShakeCurve(),
    );
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
        setState(() {
          // the animation object’s value is the changed state
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint('building 24');
    return DoubleBackToCloseWidget(
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
  }

  void _showValidation(bool isValid) {
    if (!isValid) {
      controller.forward();
    }
  }
}

List<Widget> _buildCircles(String enteredPassCode) {
  final list = <Widget>[];
  for (var i = 0; i < 4; ++i) {
    list.add(
      Container(
        margin: const EdgeInsets.all(8),
        child: Circle(
          isFilled: i < enteredPassCode.length,
        ),
      ),
    );
  }
  return list;
}

Widget _buildKeyBoard(KeyboardTapCallback _onTap, DeleteTapCallback onDelTap,
    FingerTapCallback? onFingerTap, String enteredPassCode) {
  return Keyboard(
    onKeyboardTap: _onTap,
    onDelTap: onDelTap,
    onFingerTap: onFingerTap,
  );
}

Widget _buildCancelButton(BuildContext context) {
  return Row(
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
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        },
      ),
    ],
  );
}

class Keyboard extends StatelessWidget {
  Keyboard(
      {Key? key,
      required this.onKeyboardTap,
      required this.onDelTap,
      this.onFingerTap})
      : super(key: key);

  final KeyboardTapCallback onKeyboardTap;
  final DeleteTapCallback onDelTap;
  final FingerTapCallback? onFingerTap;
  final List<String> keyBoardItem = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '-1',
    '0',
    '-1'
  ];

  Widget _buildDigit(String text) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              onKeyboardTap(text);
            },
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    text,
                    semanticsLabel: text,
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExtra(Widget widget, DeleteTapCallback? onDelTap) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              onDelTap!();
            },
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: widget,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint('building 25');
    return CustomAlign(
      children: List.generate(12, (index) {
        return index == 9 || index == 11
            ? index == 9
                ? onFingerTap == null || !myNotes.lockChecker.bioAvailable
                    ? Container()
                    : _buildExtra(
                        const Icon(Icons.fingerprint_outlined), onFingerTap)
                : _buildExtra(const Icon(Icons.backspace_outlined), onDelTap)
            : _buildDigit(
                keyBoardItem[index],
              );
      }),
    );
  }
}

class CustomAlign extends StatelessWidget {
  const CustomAlign({Key? key, required this.children}) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    //debugPrint('building 26');
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(25),
      children: children
          .map(
            (e) => SizedBox(
              width: 5,
              height: 5,
              child: e,
            ),
          )
          .toList(),
    );
  }
}

class Circle extends StatefulWidget {
  const Circle({Key? key, required this.isFilled}) : super(key: key);

  final bool isFilled;

  @override
  _CircleState createState() => _CircleState();
}

class _CircleState extends State<Circle> {
  @override
  Widget build(BuildContext context) {
    //debugPrint('building 27 ');
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: widget.isFilled
            ? selectedAppTheme == AppTheme.Light
                ? selectedPrimaryColor
                : Colors.white
            : Colors.transparent,
        shape: BoxShape.circle,

        //TODO rectify this as per current theme
        border: Border.all(
            color: selectedAppTheme == AppTheme.Light
                ? selectedPrimaryColor
                : Colors.white,
            width: 2),
      ),
    );
  }
}

class ShakeCurve extends Curve {
  @override
  double transform(double t) {
    return sin(t * 2.5 * pi).abs();
  }
}
