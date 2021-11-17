import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

final RouteObserver<Route> routeObserver = RouteObserver<Route>();

//TODO fix this and remove its status as global variable
late Encrypt encryption;

class MyNotes extends StatefulWidget {
  const MyNotes({
    Key? key,
  }) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    final state = context.findAncestorStateOfType<_MyNotesState>();
    state!.setLocale(newLocale);
  }

  @override
  _MyNotesState createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Future<void> didChangeDependencies() async {
    await getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider<NotesHelper>(
            create: (_) => NotesHelper(),
          ),
          ChangeNotifierProvider<AppConfiguration>(
            create: (_) => AppConfiguration(),
          ),
          ChangeNotifierProvider<LockChecker>(
            create: (_) => LockChecker(),
          ),
          ChangeNotifierProvider<Auth>(
            create: (_) => Auth(),
          ),
        ],
        child: Builder(
          builder: (context) {
            Provider.of<AppConfiguration>(context);
            final curUser =
                Provider.of<Auth>(context, listen: false).auth.currentUser;
            if (curUser != null) {
              logger.i('Initialising firebase');
              Utilities.initialize(context);
            }
            final supportedLocales = <Locale>[];
            for (final element in supportedLanguages) {
              supportedLocales.add(Locale(element.languageCode, ''));
            }
            return MaterialApp(
              locale: _locale,
              restorationScopeId: 'keepnotes',
              supportedLocales: supportedLocales,
              localizationsDelegates: const [
                AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                for (final supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale?.languageCode &&
                      supportedLocale.countryCode == locale?.countryCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
              theme: Provider.of<AppConfiguration>(context, listen: false)
                  .currentTheme,
              title: Language.of(context).appTitle,
              home: Provider.of<Auth>(context, listen: false).isLoggedIn
                  ? const ScreenContainer(
                      topScreen: ScreenTypes.home,
                    )
                  : const Welcome(),
              debugShowCheckedModeBanner: false,
              navigatorObservers: [routeObserver],
              onGenerateRoute: RouteGenerator.generateRoute,
            );
          },
        ),
      );
}

//TODO fix splash screen android S
