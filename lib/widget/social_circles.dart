//24-11-2021 09:04 PM
import 'package:notes/_app_packages.dart';
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
        margin:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
        padding: EdgeInsets.all(getProportionateScreenWidth(12)),
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenWidth(40),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F6F9),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(icon!),
      ),
    );
  }
}
