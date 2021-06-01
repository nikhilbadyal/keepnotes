import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:notes/model/Languages.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/util/AppConfiguration.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/Encryption.dart';
import 'package:notes/util/LockManager.dart';
import 'package:provider/provider.dart';

final RouteObserver<Route> routeObserver = RouteObserver<Route>();

//TODO fix this and remove its status as global variable
late Encrypt encryption;

class MyNotes extends StatefulWidget {
  const MyNotes(
    this.password, {
    required this.locale,
    Key? key,
  }) : super(key: key);

  final Locale locale;
  final String password;

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
            create: (_) => LockChecker(widget.password),
          ),
        ],
        child: Builder(
          builder: (context) {
            Provider.of<AppConfiguration>(context);
            final lockChecker = Provider.of<LockChecker>(context);
            encryption = Encrypt(lockChecker.password);
            final supportedLocales = <Locale>[];
            supportedLanguages.forEach((element) =>
                supportedLocales.add(Locale(element.languageCode, '')));
            return MaterialApp(
             /* checkerboardOffscreenLayers: true,
              checkerboardRasterCacheImages: true,*/
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
              initialRoute: '/',
              debugShowCheckedModeBanner: false,
              onGenerateRoute: RouteGenerator.generateRoute,
            );
          },
        ),
      );
}
