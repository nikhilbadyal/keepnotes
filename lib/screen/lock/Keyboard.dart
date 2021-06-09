import 'package:notes/_externalPackages.dart';
import 'package:notes/_internalPackages.dart';
import 'package:notes/util/_util.dart';

typedef KeyboardTapCallback = void Function(String text);
typedef DeleteTapCallback = void Function();
typedef FingerTapCallback = void Function();
typedef DoneCallBack = void Function(String text);
typedef DoneEntered = Future<void> Function(String enteredPassCode);

class Keyboard extends StatelessWidget {
  const Keyboard(
      {required this.onKeyboardTap,
      required this.onDelTap,
      this.onFingerTap,
      this.keyBoardItem = const [
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
      ],
      Key? key})
      : super(key: key);

  final KeyboardTapCallback onKeyboardTap;
  final DeleteTapCallback onDelTap;
  final FingerTapCallback? onFingerTap;
  final List<String>? keyBoardItem;

  Widget buildExtra(Widget widget, DeleteTapCallback? onDelTap) => Container(
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

  Widget buildDigit(String text) => SizedBox(
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

  @override
  Widget build(BuildContext context) => CustomAlign(
        children: List.generate(
          12,
          (index) => index == 9 || index == 11
              ? index == 9
                  ? onFingerTap == null ||
                          !Provider.of<LockChecker>(context, listen: false)
                              .bioAvailable
                      ? Container()
                      : buildExtra(
                          const Icon(Icons.fingerprint_outlined), onFingerTap)
                  : buildExtra(const Icon(Icons.backspace_outlined), onDelTap)
              : buildDigit(
                  keyBoardItem![index],
                ),
        ),
      );
}

class CustomAlign extends StatelessWidget {
  const CustomAlign({
    required this.children,
    Key? key,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(15),
        children: children
            .map(
              (e) => e,
            )
            .toList(),
      );
}
