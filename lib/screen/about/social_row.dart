import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class SocialLinksRow extends StatelessWidget {
  const SocialLinksRow({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) => Container(
        margin: const EdgeInsets.only(left: 12, right: 12, top: 16),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => launch('https://t.me/joinchat/uGAlVliNij1hZTFl'),
              child: SvgPicture.asset('assets/images/telegram.svg'),
            ),
            GestureDetector(
                onTap: () => launch(
                    'https://github.com/ProblematicDude/keep-safe-notes'),
                child: SvgPicture.asset('assets/images/github.svg')),
          ],
        ),
      );
}
