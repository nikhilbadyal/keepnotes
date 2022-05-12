//30-11-2021 01:11 PM
import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.title,
    required this.onTap,
    final Key? key,
    this.pad = true,
  }) : super(key: key);
  final Widget title;
  final bool pad;

  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.canvasColor,
        ),
        alignment: Alignment.center,
        child: title,
      ),
    );
  }
}
