import 'package:notes/_appPackages.dart';
import 'package:notes/_externalPackages.dart';
import 'package:notes/_internalPackages.dart';



class SimpleLogPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.levelColors[event.level];
    final emoji = PrettyPrinter.levelEmojis[event.level];
    final str = color!('$emoji - ${event.message}');
    return [str];
  }
}

Logger logger = Logger(
  printer: SimpleLogPrinter(),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Utilities.prefs = await SharedPreferences.getInstance();
  Utilities.storage = const FlutterSecureStorage();
  final password = await Utilities.storage.read(key: 'password') ?? '';
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
      ),
    ),
  );
}
