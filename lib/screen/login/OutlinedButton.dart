import 'package:notes/_internalPackages.dart';

class OutlineBtn extends StatefulWidget {
  const OutlineBtn({
    required this.btnText,
    required this.onTap,
    Key? key,
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).accentColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            widget.btnText,
            style:
                TextStyle(color: Theme.of(context).accentColor, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
