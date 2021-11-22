import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

final RouteObserver<Route> routeObserver = RouteObserver<Route>();

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
  _MyNotesState createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {
  Locale? _locale;

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
  Widget build(final BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider<NotesHelper>(
            create: (final _) => NotesHelper(),
          ),
          ChangeNotifierProvider<AppConfiguration>(
            create: (final _) => AppConfiguration(),
          ),
          ChangeNotifierProvider<LockChecker>(
            create: (final _) => LockChecker(),
          ),
          ChangeNotifierProvider<Auth>(
            create: (final _) => Auth(),
          ),
        ],
        child: Builder(
          builder: (final context) {
            Provider.of<AppConfiguration>(context);
            final curUser =
                Provider.of<Auth>(context, listen: false).auth.currentUser;
            if (curUser != null) {
              Utilities.initialize(context);
            }
            final supportedLocales = <Locale>[];
            for (final element in supportedLanguages) {
              supportedLocales.add(Locale(element.languageCode, ''));
            }
            final initRoute =
                Provider.of<Auth>(context, listen: false).isLoggedIn
                    ? '/'
                    : 'welcome';
            final primaryColor =
                Color(getIntFromSF('primaryColor') ?? defaultPrimary.value);
            final accentColor =
                Color(getIntFromSF('accentColor') ?? defaultAccent.value);
            final appTheme = AppTheme.values[getIntFromSF('appTheme') ?? 0];
            final currentTheme = appTheme == AppTheme.light
                ? lightTheme(primaryColor, accentColor)
                : blackTheme(primaryColor, accentColor);
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
              localeResolutionCallback: (final locale, final supportedLocales) {
                for (final supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale?.languageCode &&
                      supportedLocale.countryCode == locale?.countryCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
              theme: currentTheme,
              title: Language.of(context).appTitle,
              initialRoute: initRoute,
              debugShowCheckedModeBanner: false,
              navigatorObservers: [routeObserver],
              onGenerateRoute: RouteGenerator.generateRoute,
            );
          },
        ),
      );
}
