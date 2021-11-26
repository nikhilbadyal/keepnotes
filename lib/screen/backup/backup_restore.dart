import 'package:notes/_app_packages.dart';
import 'package:notes/_internal_packages.dart';

class BackUpScreen extends StatefulWidget {
  const BackUpScreen({final Key? key}) : super(key: key);

  @override
  _BackUpScreenState createState() => _BackUpScreenState();
}

class _BackUpScreenState extends State<BackUpScreen>
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
                  Language.of(context).soon,
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
