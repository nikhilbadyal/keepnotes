//11-12-2021 10:42 PM

import 'dart:ui';

import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';
import 'package:notes/widget/floating_dots.dart';

class PinCode extends StatefulWidget {
  const PinCode({final Key? key}) : super(key: key);

  @override
  _PinCodeState createState() => _PinCodeState();
}

class _PinCodeState extends State<PinCode> {
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();

  @override
  Widget build(final BuildContext context) {
    final val = MediaQuery.of(context).size.width - kToolbarHeight - 24;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: FloatingDotGroup(
                number: 10,
                size: DotSize.large,
                colors: [Theme.of(context).colorScheme.secondary],
                speed: DotSpeed.fast,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: val * 0.1,
                      ),
                      Icon(
                        Icons.lock_outlined,
                        size: val * 0.06,
                      ),
                      SizedBox(
                        height: val * 0.05,
                      ),
                      Text(
                        'Enter Pin',
                        style: TextStyle(
                          fontSize: 3 * textMultiplier,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: val * 0.05,
                      ),
                      PinCodeBoxes(
                        pinPutController: _pinPutController,
                        pinPutFocusNode: _pinPutFocusNode,
                        doneCallBack: (_){},
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      GridView.count(
                        padding: const EdgeInsets.all(30),
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        childAspectRatio: 1.55,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          ...[1, 2, 3, 4, 5, 6, 7, 8, 9].map((final e) {
                            return InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () {
                                HapticFeedback.heavyImpact();
                                if (_pinPutController.text.length >=
                                    (pinCodeLen + 1)) {
                                  return;
                                }
                                _pinPutController.text =
                                '${_pinPutController.text}$e';
                              },
                              child: Center(
                                child: Text(
                                  '$e',
                                  style: const TextStyle(fontSize: keyPadNumberSize),
                                ),
                              ),
                            );
                          }),
                          if (Provider.of<AppConfiguration>(context).bioNotAvailable)
                            Container()
                          else
                            const InkWell(
                              customBorder: CircleBorder(),
                              onTap: HapticFeedback.heavyImpact,
                              child: Icon(Icons.fingerprint_outlined),
                            ),
                          InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              SystemSound.play(SystemSoundType.click);

                              if (_pinPutController.text.length >= (pinCodeLen + 1)) {
                                return;
                              }

                              _pinPutController.text = '${_pinPutController.text}0';
                            },
                            child: const Center(
                              child: Text(
                                '0',
                                style: TextStyle(fontSize: keyPadNumberSize),
                              ),
                            ),
                          ),
                          InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              HapticFeedback.heavyImpact();

                              if (_pinPutController.text.isNotEmpty) {
                                _pinPutController.text =
                                    _pinPutController.text.substring(
                                      0,
                                      _pinPutController.text.length - 1,
                                    );
                              }
                            },
                            child: const Center(
                              child: Text(
                                '⌫',
                                style: TextStyle(fontSize: keyPadNumberSize),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
/*
Column(
            children: [
              SizedBox(
                height: val * 0.12,
              ),
              Icon(
                Icons.lock_outlined,
                size: val * 0.06,
              ),
              SizedBox(
                height: val * 0.05,
              ),
              SizedBox(
                height: val * 0.09,
                child: const Text('Enter pincode'),
              ),
              SizedBox(
                height: val * 0.1,
                child: PinCodeBoxes(
                  pinPutController: _pinPutController,
                  pinPutFocusNode: _pinPutFocusNode,
                  doneCallBack: (final _) {},
                ),
              ),
              SizedBox(
                height: val * 0.6,
                child: GridView.count(
                  padding: const EdgeInsets.all(30),
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ...[1, 2, 3, 4, 5, 6, 7, 8, 9].map((final e) {
                      return InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          if (_pinPutController.text.length >=
                              (pinCodeLen + 1)) {
                            return;
                          }
                          _pinPutController.text =
                              '${_pinPutController.text}$e';
                        },
                        child: Center(
                          child: Text(
                            '$e',
                            style:
                                const TextStyle(fontSize: keyPadNumberSize),
                          ),
                        ),
                      );
                    }),
                    if (Provider.of<AppConfiguration>(context)
                        .bioNotAvailable)
                      Container()
                    else
                      const InkWell(
                        customBorder: CircleBorder(),
                        onTap: HapticFeedback.heavyImpact,
                        child: Icon(Icons.fingerprint_outlined),
                      ),
                    InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        SystemSound.play(SystemSoundType.click);

                        if (_pinPutController.text.length >=
                            (pinCodeLen + 1)) {
                          return;
                        }

                        _pinPutController.text = '${_pinPutController.text}0';
                      },
                      child: const Center(
                        child: Text(
                          '0',
                          style: TextStyle(fontSize: keyPadNumberSize),
                        ),
                      ),
                    ),
                    InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        HapticFeedback.heavyImpact();

                        if (_pinPutController.text.isNotEmpty) {
                          _pinPutController.text =
                              _pinPutController.text.substring(
                            0,
                            _pinPutController.text.length - 1,
                          );
                        }
                      },
                      child: const Center(
                        child: Text(
                          '⌫',
                          style: TextStyle(fontSize: keyPadNumberSize),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          )
 */
