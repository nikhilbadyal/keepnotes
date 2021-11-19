import 'package:notes/_internal_packages.dart';

class OutlineBtn extends StatefulWidget {
  const OutlineBtn({
    required this.btnText,
    required this.onTap,
    final Key? key,
  }) : super(
          key: key,
        );

  final String btnText;
  final Function() onTap;

  @override
  _OutlineBtnState createState() => _OutlineBtnState();
}

class _OutlineBtnState extends State<OutlineBtn> {
  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            widget.btnText,
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
