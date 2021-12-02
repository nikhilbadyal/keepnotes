//26-11-2021 11:18 PM
import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class KeyPad extends StatelessWidget {
  const KeyPad({
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
      // color: Colors.black,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
    return Padding(
        padding: const EdgeInsets.only(left: 65, right: 65),
        child: PinPut(
          useNativeKeyboard: false,
          fieldsCount: pinCodeLen,
          withCursor: true,
          textStyle: const TextStyle(fontSize: 20),
          eachFieldWidth: 55,
          eachFieldHeight: 35,
          onSubmit: (final pass) async {
            doneCallBack.call(pass);
            await Future.delayed(const Duration(milliseconds: pinEnterReset),);
            pinPutController.clear();
          },
          focusNode: pinPutFocusNode,
          controller: pinPutController,
          submittedFieldDecoration: submitted,
          selectedFieldDecoration: currentDecoration,
          followingFieldDecoration: submitted,
          pinAnimationType: PinAnimationType.fade,
        ),);
  }
}
