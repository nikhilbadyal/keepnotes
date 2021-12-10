//24-11-2021 09:09 PM
import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

class DefaultButton extends StatefulWidget {
  const DefaultButton({
    final Key? key,
    this.text,
    this.press,
  }) : super(key: key);
  final String? text;
  final Function? press;

  @override
  State<DefaultButton> createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 5 * SizeConfig.widthMultiplier,
        right: 5 * SizeConfig.widthMultiplier,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 7 * heightMultiplier,
        child: TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            primary: Colors.white,
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: widget.press as void Function()?,
          child: Text(
            widget.text!,
            style: TextStyle(
              fontSize: 2.3 * textMultiplier,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
