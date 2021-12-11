import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class SocialLinksRow extends StatefulWidget {
  const SocialLinksRow({
    final Key? key,
  }) : super(key: key);

  @override
  State<SocialLinksRow> createState() => _SocialLinksRowState();
}

class _SocialLinksRowState extends State<SocialLinksRow> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 3.1 * widthMultiplier,
        right: 3.1 * widthMultiplier,
        top: 1.88 * heightMultiplier,
      ),
      height: 5.88 * heightMultiplier,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => launch(telegramUrl),
            child: SvgPicture.asset(telegram),
          ),
          GestureDetector(
            onTap: () => launch(repoLink),
            child: SvgPicture.asset(github),
          ),
        ],
      ),
    );
  }
}
