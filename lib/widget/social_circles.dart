//24-11-2021 09:04 PM
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class SocialCard extends StatelessWidget {
  const SocialCard({
    final Key? key,
    this.icon,
    this.press,
  }) : super(key: key);

  final String? icon;
  final Function? press;

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: press as void Function()?,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 4,
        ),
        padding: const EdgeInsets.all(
          4,
        ),
        height: 16,
        width: 36,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F6F9),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(icon!),
      ),
    );
  }
}
