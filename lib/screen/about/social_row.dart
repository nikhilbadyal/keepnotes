import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

Widget myBuilder(
    final BuildContext context, final AsyncSnapshot<dynamic> snapshot) {
  if (snapshot.connectionState == ConnectionState.done) {
    return snapshot.data ?? const CircularProgressIndicator();
  } else {
    return const CircularProgressIndicator();
  }
}

class SocialLinksRow extends StatefulWidget {
  const SocialLinksRow({final Key? key}) : super(key: key);

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
      margin: const EdgeInsets.only(left: 12, right: 12, top: 16),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
              onTap: () => launch('https://t.me/joinchat/uGAlVliNij1hZTFl'),
              child: SvgPicture.asset(telegram)),
          GestureDetector(
              onTap: () => launch('https://github.com/nikhilbadyal/keep-notes'),
              child: SvgPicture.asset(github)),
        ],
      ),
    );
  }
}
