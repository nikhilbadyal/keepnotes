//30-11-2021 01:11 PM
import 'package:notes/_internal_packages.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {required this.title, required this.onTap, final Key? key,})
      : super(key: key);
  final Widget title;

  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).canvasColor,
        ),
        alignment: Alignment.center,
        child: title,
      ),
    );
  }
}
