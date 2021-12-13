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
    final submitted = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Colors.grey,
      ),
    );
    final currentDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8 * heightMultiplier),
      child: PinPut(
        // autofocus: true,
        useNativeKeyboard: false,
        fieldsCount: pinCodeLen,
        withCursor: true,
        textStyle: TextStyle(fontSize: 5.12 * widthMultiplier),
        eachFieldWidth: 14 * widthMultiplier,
        eachFieldHeight: 14 * widthMultiplier,
        onSubmit: (final pass) async {
          doneCallBack.call(pass);
          await Future.delayed(
            const Duration(milliseconds: pinEnterReset),
          );
          pinPutController.clear();
        },
        focusNode: pinPutFocusNode,
        controller: pinPutController,
        submittedFieldDecoration: submitted,
        selectedFieldDecoration: currentDecoration,
        followingFieldDecoration: submitted,
        pinAnimationType: PinAnimationType.fade,
      ),
    );
  }
}
