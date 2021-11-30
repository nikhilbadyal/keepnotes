import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

// Add your own DSN if you want.
// Read here https://docs.sentry.io/platforms/flutter/
const dsn = dsnLink;

final sentry = SentryClient(SentryOptions(dsn: dsn));

class SimpleLogPrinter extends LogPrinter {
  @override
  List<String> log(final LogEvent event) {
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
  if (kDebugMode) {
    timeDilation = 1.5;
  }
  FlutterError.onError = (final details, {final forceReport = false}) {
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      sentry.captureException(
        details.exception,
        stackTrace: details.stack,
      );
    }
  };
  Future<void> reportError(
      final Object error, final StackTrace stackTrace) async {
    if (kReleaseMode) {
      try {
        await sentry.captureException(
          error,
          stackTrace: stackTrace,
        );
      } on Error catch (e, s) {
        logger.w('reportError $e $s');
      }
    } else {
      logger.e('reportError debugMode $error $stackTrace');
    }
  }

  if (dsn.isNotEmpty || kDebugMode) {
    await runZonedGuarded(() async {
      runApp(const MyNotes());
    }, reportError);
  } else {
    logger.w('reportError DNS NOT FOUND');
    exit(1);
  }
}
