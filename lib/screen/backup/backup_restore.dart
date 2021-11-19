import 'package:notes/_app_packages.dart';
import 'package:notes/_internal_packages.dart';

class BackUpScreenHelper extends StatefulWidget {
  const BackUpScreenHelper({final Key? key}) : super(key: key);

  @override
  _BackUpScreenHelperState createState() => _BackUpScreenHelperState();
}

class _BackUpScreenHelperState extends State<BackUpScreenHelper>
    with TickerProviderStateMixin {
  @override
  Widget build(final BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const ImageWig(),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Text(
                  'Feature will be live Soon',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).textTheme.bodyText1!.color),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
