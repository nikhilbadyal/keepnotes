/*

class MySimpleDialog extends StatelessWidget {
  const MySimpleDialog({
    required this.title,
    this.children = const [],
    Key? key,
  }) : super(key: key);

  final Widget title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Center(
          child: title,
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade900),
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        children: children,
      );
}
*/
