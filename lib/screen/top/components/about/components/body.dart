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
              child: InkWell(
                onTap: () {
                  urlLauncher(githubProfile);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 50,
                  child: SvgPicture.asset(me),
                ),
              ),
            ),
            const Divider(
              height: 62,
              indent: 12,
              endIndent: 12,
            ),
            Text(
              context.language.name,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Product Sans',
                color: context.theme.textTheme.bodyText1!.color,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              context.language.devName,
              style: TextStyle(
                color: context.secondaryColor,
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              context.language.email,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Product Sans',
                color: context.theme.textTheme.bodyText1!.color,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: <Widget>[
                const Icon(Icons.email),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () async => urlLauncher(
                    emailLaunchUri.toString(),
                  ),
                  child: Text(
                    'nikhildevelops@gmail.com',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: context.secondaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              height: 62,
              indent: 12,
              endIndent: 12,
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 16,
                top: 8.3,
              ),
              child: Center(
                child: Text(
                  context.language.social,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Product Sans',
                    color: context.theme.textTheme.bodyText1!.color,
                  ),
                ),
              ),
            ),
            const SocialLinksRow(),
            const SizedBox(height: 16),
            const Divider(
              height: 62,
              indent: 12,
              endIndent: 12,
            ),
          ],
        ),
      ),
    );
  }
}
