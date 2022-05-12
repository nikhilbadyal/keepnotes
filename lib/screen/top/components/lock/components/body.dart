import 'dart:ui';

import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';
import 'package:notes/widget/floating_dots.dart';

class LockBody extends StatefulWidget {
  const LockBody({
    required this.doneCallBack,
    required this.title,
    this.onFingerTap,
    final Key? key,
  }) : super(key: key);

  final DoneCallBack doneCallBack;
  final OnTap? onFingerTap;
  final String title;

  @override
  _LockBodyState createState() => _LockBodyState();
}

class _LockBodyState extends State<LockBody> {
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();

  @override
  Widget build(final BuildContext context) {
    return OrientationBuilder(
      builder: (final context, final orientation) {
        return orientation == Orientation.portrait
            ? buildPotrait()
            : buildLandscape();
      },
    );
  }

  Widget buildPotrait() {
    return SafeArea(
      child: Stack(
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
          Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              const Icon(
                Icons.lock_outlined,
                size: 48,
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 72,
                child: Text(
                  widget.title,
                ),
              ),
              SizedBox(
                height: 80,
                child: PinCodeBoxes(
                  pinPutController: _pinPutController,
                  pinPutFocusNode: _pinPutFocusNode,
                  doneCallBack: widget.doneCallBack,
                ),
              ),
              SizedBox(
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
                            style: const TextStyle(fontSize: keyPadNumberSize),
                          ),
                        ),
                      );
                    }),
                    if (Provider.of<AppConfiguration>(context)
                            .bioNotAvailable ||
                        widget.onFingerTap == null)
                      Container()
                    else
                      InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          widget.onFingerTap!.call();
                        },
                        child: const Icon(Icons.fingerprint_outlined),
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
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildLandscape() {
    final val = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Stack(
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
                      height: val * 0.03,
                    ),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: val * 0.05,
                    ),
                    PinCodeBoxes(
                      pinPutController: _pinPutController,
                      pinPutFocusNode: _pinPutFocusNode,
                      doneCallBack: widget.doneCallBack,
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
                                style:
                                    const TextStyle(fontSize: keyPadNumberSize),
                              ),
                            ),
                          );
                        }),
                        if (Provider.of<AppConfiguration>(context)
                                .bioNotAvailable ||
                            widget.onFingerTap == null)
                          Container()
                        else
                          InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              widget.onFingerTap!.call();
                            },
                            child: const Icon(Icons.fingerprint_outlined),
                          ),
                        InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            if (_pinPutController.text.length >=
                                (pinCodeLen + 1)) {
                              return;
                            }

                            _pinPutController.text =
                                '${_pinPutController.text}0';
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
