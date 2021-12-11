import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({
    final Key? key,
  }) : super(key: key);

  @override
  _AboutMeState createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> with TickerProviderStateMixin {
  @override
  Widget build(final BuildContext context) => body(context);

  Widget body(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: GestureDetector(
                onTap: () {
                  launchUrl(githubProfile);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 50,
                  child: SvgPicture.asset(me),
                ),
              ),
            ),
            Divider(
              height: 7.05 * heightMultiplier,
              indent: 12,
              endIndent: 12,
            ),
            Text(
              Language.of(context).name,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Product Sans',
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            SizedBox(height: 3.52 * heightMultiplier),
            Text(
              Language.of(context).devName,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 2.35 * textMultiplier,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 3.52 * heightMultiplier),
            Text(
              Language.of(context).email,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Product Sans',
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            SizedBox(height: 3.52 * heightMultiplier),
            Row(
              children: <Widget>[
                const Icon(Icons.email),
                SizedBox(
                  width: 2.56 * widthMultiplier,
                ),
                GestureDetector(
                  onTap: () async => launchUrl(
                    emailLaunchUri.toString(),
                  ),
                  child: Text(
                    'nikhildevelops@gmail.com',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 1.8 * textMultiplier,
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              height: 7 * heightMultiplier,
              indent: 12,
              endIndent: 12,
            ),
            Container(
              margin: EdgeInsets.only(
                left: 4.1 * widthMultiplier,
                top: 0.94 * heightMultiplier,
              ),
              child: Center(
                child: Text(
                  Language.of(context).social,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Product Sans',
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
              ),
            ),
            const SocialLinksRow(),
            SizedBox(height: 1.88 * heightMultiplier),
            Divider(
              height: 7 * heightMultiplier,
              indent: 12,
              endIndent: 12,
            ),
          ],
        ),
      ),
    );
  }
}
