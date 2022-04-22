//26-11-2021 11:18 PM
import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class PinCodeBoxes extends StatelessWidget {
  const PinCodeBoxes({
    required this.doneCallBack,
    required this.pinPutController,
    required this.pinPutFocusNode,
    final Key? key,
  }) : super(key: key);
  final DoneCallBack doneCallBack;
  final TextEditingController pinPutController;
  final FocusNode pinPutFocusNode;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Pinput(
        useNativeKeyboard: false,
        onCompleted: (final pass) async {
          doneCallBack.call(pass);
          await Future.delayed(
            const Duration(milliseconds: pinEnterReset),
          );
          pinPutController.clear();
        },
        focusNode: pinPutFocusNode,
        controller: pinPutController,
        pinAnimationType: PinAnimationType.fade,
      ),
    );
  }
}
