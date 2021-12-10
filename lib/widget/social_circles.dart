//24-11-2021 09:04 PM
import 'package:notes/_aap_packages.dart';
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
        margin: EdgeInsets.symmetric(
          horizontal: 1 * SizeConfig.widthMultiplier,
        ),
        padding: EdgeInsets.all(
          1 * SizeConfig.widthMultiplier,
        ),
        height: 4 * heightMultiplier,
        width: 9 * SizeConfig.widthMultiplier,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F6F9),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(icon!),
      ),
    );
  }
}
