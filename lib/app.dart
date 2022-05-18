import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

final RouteObserver<Route<void>> routeObserver = RouteObserver<Route<void>>();

late Encrypt encryption;
final LocalAuthentication localAuthentication = LocalAuthentication();

class MyNotes extends StatefulWidget {
  const MyNotes({
    final Key? key,
  }) : super(key: key);

  static void setLocale(final BuildContext context, final Locale newLocale) {
    final state = context.findAncestorStateOfType<_MyNotesState>();
    state!.setLocale(newLocale);
  }

  @override
  State<MyNotes> createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {
  Locale? _locale;
  final supportedLocales = <Locale>[];

  Iterable<LocalizationsDelegate<dynamic>>? localizationDelegates = [
    const AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  @override
  void initState() {
    super.initState();
    for (final element in supportedLanguages) {
      supportedLocales.add(
        Locale(element.languageCode, ''),
      );
    }
  }

  void setLocale(final Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Future<void> didChangeDependencies() async {
    await getLocale().then((final locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(final BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotesHelper>(
          create: (final context) => NotesHelper(),
        ),
        ChangeNotifierProvider<AppConfiguration>(
          create: (final context) => AppConfiguration(),
        ),
        ChangeNotifierProvider<FirebaseAuthentication>(
          create: (final context) => FirebaseAuthentication(),
        ),
      ],
      child: Builder(
        builder: (final context) {
          context.appConfig;
          final curUser = context.firebaseAuth.auth.currentUser;
          if (curUser != null) {
            context.appConfig.password = initialize(curUser);
          }
          final initRoute = context.firebaseAuth.isLoggedIn ? '/' : 'intro';
          return LayoutBuilder(
            builder: (final context, final constraints) {
              return OrientationBuilder(
                builder: (final context, final orientation) {
                  return MaterialApp(
                    locale: _locale,
                    restorationScopeId: 'keepnotes',
                    supportedLocales: supportedLocales,
                    localizationsDelegates: localizationDelegates,
                    localeResolutionCallback: localeResolutionCallback,
                    theme: getThemeData(),
                    title: context.language.appTitle,
                    initialRoute: initRoute,
                    debugShowCheckedModeBanner: false,
                    navigatorObservers: [routeObserver],
                    onGenerateRoute: generateRoute,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Locale? localeResolutionCallback(
    final Locale? locale,
    final Iterable<Locale> supportedLocales,
  ) {
    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale?.languageCode &&
          supportedLocale.countryCode == locale?.countryCode) {
        return supportedLocale;
      }
    }
    return supportedLocales.first;
  }
}
