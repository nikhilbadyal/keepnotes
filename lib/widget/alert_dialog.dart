import 'package:notes/_internal_packages.dart';

class MyAlertDialog extends StatelessWidget {
  const MyAlertDialog({
    required this.content,
    required this.title,
    this.actions,
    final Key? key,
  }) : super(key: key);

  final Widget title;
  final List<Widget>? actions;
  final Widget content;

  @override
  Widget build(final BuildContext context) => AlertDialog(
        title: Center(child: title),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).iconTheme.color!.withOpacity(0.1),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        content: content,
        actions: actions,
      );
}
