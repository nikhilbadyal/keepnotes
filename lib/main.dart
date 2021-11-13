import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

//TODO add while build release
const dsn = '';

final sentry = SentryClient(SentryOptions(dsn: dsn));

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
  await Firebase.initializeApp();

  Utilities.prefs = await SharedPreferences.getInstance();
  Utilities.storage = const FlutterSecureStorage();
  if (kDebugMode) {
    timeDilation = 1;
  }
  FlutterError.onError = (details, {forceReport = false}) {
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      sentry.captureException(
        details.exception,
        stackTrace: details.stack,
      );
    }
  };
  Future<void> reportError(Object error, StackTrace stackTrace) async {
    if (kReleaseMode) {
      try {
        await sentry.captureException(
          error,
          stackTrace: stackTrace,
        );
        // ignore: avoid_catching_errors
      } on Error catch (e, s) {
        logger.w('reportError $e $s');
      }
    } else {
      logger.e('reportError debugMode $error $stackTrace');
    }
  }

  if (dsn.isNotEmpty) {
    await runZonedGuarded(() async {
      return SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
      ).then((_) => runApp(const MyNotes()));
    }, reportError);
  } else {
    logger.w('reportError DNS NOT FOUND');
    exit(1);
  }
}
