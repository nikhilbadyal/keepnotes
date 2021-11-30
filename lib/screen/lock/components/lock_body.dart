import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

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
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Image.asset(otp),
        ),
        Expanded(
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
            child: KeyPad(
          pinPutController: _pinPutController,
          pinPutFocusNode: _pinPutFocusNode,
          doneCallBack: widget.doneCallBack,
        )),
        Expanded(
          flex: 8,
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 50, right: 50, top: 30),
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ...[1, 2, 3, 4, 5, 6, 7, 8, 9].map((final e) {
                return RoundedButton(
                  title: Text('$e', style: const TextStyle(fontSize: 20)),
                  onTap: () {
                    if (_pinPutController.text.length >= 5) {
                      return;
                    }

                    _pinPutController.text = '${_pinPutController.text}$e';
                  },
                );
              }),
              if (Provider.of<AppConfiguration>(context).bioNotAvailable ||
                  widget.onFingerTap == null)
                Container()
              else
                RoundedButton(
                  title: const Icon(Icons.fingerprint_outlined),
                  onTap: widget.onFingerTap,
                ),
              RoundedButton(
                title: const Text(
                  '0',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  if (_pinPutController.text.length >= 5) {
                    return;
                  }

                  _pinPutController.text = '${_pinPutController.text}0';
                },
              ),
              RoundedButton(
                title: const Text(
                  '⌫',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  if (_pinPutController.text.isNotEmpty) {
                    _pinPutController.text = _pinPutController.text
                        .substring(0, _pinPutController.text.length - 1);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
