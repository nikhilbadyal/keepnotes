import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
      margin: const EdgeInsets.only(
        left: 12,
        right: 12,
        top: 16,
      ),
      height: 52,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => launchUrlString(telegramUrl),
            child: SvgPicture.asset(telegram),
          ),
          GestureDetector(
            onTap: () => launchUrlString(repoLink),
            child: SvgPicture.asset(github),
          ),
        ],
      ),
    );
  }
}
