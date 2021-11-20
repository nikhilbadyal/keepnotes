import 'package:notes/_internal_packages.dart';

class MyAlertDialog extends StatelessWidget {
  const MyAlertDialog({
    required this.content,
    this.title,
    this.actions,
    final Key? key,
  }) : super(key: key);

  final Widget? title;
  final List<Widget>? actions;
  final Widget content;

  @override
  Widget build(final BuildContext context) {
    return AlertDialog(
      title: title,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: content,
      actions: actions,
    );
  }
}
