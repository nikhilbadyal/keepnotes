import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  const MyAlertDialog({
    required this.content,
    required this.title,
    this.actions,
    Key? key,
  }) : super(key: key);

  final Widget title;
  final List<Widget>? actions;
  final Widget content;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: title,
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
