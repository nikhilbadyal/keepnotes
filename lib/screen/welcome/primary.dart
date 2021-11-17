import 'package:notes/_internal_packages.dart';

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({required this.btnText, required this.onTap, Key? key})
      : super(key: key);

  final Function() onTap;
  final String btnText;

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(50)),
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              widget.btnText,
              style: TextStyle(
                color: Theme.of(context).canvasColor,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
