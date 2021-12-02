//24-11-2021 09:09 PM
import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    final Key? key,
    this.text,
    this.press,
  }) : super(key: key);
  final String? text;
  final Function? press;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
          primary: Colors.white,
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        onPressed: press as void Function()?,
        child: Text(
          text!,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
