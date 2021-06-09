import 'package:notes/_externalPackages.dart';
import 'package:notes/_internalPackages.dart';
import 'package:notes/app.dart';
import 'package:notes/model/_model.dart';
import 'package:notes/util/_util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Utilities.prefs = await SharedPreferences.getInstance();
  Utilities.storage = const FlutterSecureStorage();
  final password = await Utilities.storage.read(key: 'password') ?? '';
  final locale = await getLocale();
  FlutterError.onError = (details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode || kDebugMode) {
      exit(1);
    }
  };

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then(
    (_) => runApp(
      MyNotes(
        password,
        locale: locale,
      ),
    ),
  );
}
