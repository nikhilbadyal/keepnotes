import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:notes/model/database/Encryption.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/util/AppConfiguration.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/Languages/Languages.dart';
import 'package:notes/util/ThemeData.dart';
import 'package:provider/provider.dart';

late _MyNotesState myNotes;

final RouteObserver<Route> routeObserver = RouteObserver<Route>();

//It manages everything related to password screen

//It manages everything related to AES encryption.
Encrypt encryption = Encrypt();

class MyNotes extends StatefulWidget {
  const MyNotes({Key? key, required this.locale}) : super(key: key);

  final Locale locale;

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
  Widget build(BuildContext context) {
    myNotes = this;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotesHelper>(
          create: (_) => NotesHelper(),
        ),
        ChangeNotifierProvider<AppConfiguration>(
          create: (_) => AppConfiguration(),
        ),
      ],
      child: Builder(
        builder: (BuildContext context) {
          Provider.of<AppConfiguration>(context);
          ThemeData _theme;
          final currentTheme =
              Provider.of<AppConfiguration>(context, listen: false).appTheme;
          if (currentTheme == AppTheme.Black) {
            _theme = blackTheme(context);
          } else {
            _theme = lightTheme(context);
          }
          /* final _statusBarBrightness = selectedAppTheme == AppTheme.Black
              ? Brightness.dark
              : Brightness.light;*/

          // Sync status bar and nav bar with current theme

          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: selectedAppTheme == AppTheme.Light
                  ? selectedPrimaryColor
                  : Colors.transparent,
              /* statusBarBrightness: selectedAppTheme == AppTheme.Light
                  ? Brightness.dark
                  : Brightness.light,
              statusBarIconBrightness: selectedAppTheme == AppTheme.Light
                  ? Brightness.light
                  : Brightness.dark,
              systemNavigationBarColor: selectedAppTheme == AppTheme.Light
                  ? Colors.white
                  : Colors.black,
              systemNavigationBarIconBrightness:
                  selectedAppTheme == AppTheme.Light
                      ? Brightness.dark
                      : Brightness.light, */
            ),
          );
          final supportedLocales = <Locale>[];
          // ignore: avoid_function_literals_in_foreach_calls
          supportedLanguages.forEach((element) =>
              supportedLocales.add(Locale(element.languageCode, '')));
          return MaterialApp(
            locale: _locale,
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
            /*locale: _locale,
            localizationsDelegates: [
              FallbackLocalizationDelegate(),
              const AppLocalizationsDelegate(),
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
            },*/
            theme: _theme,
            title: Languages.of(context).appTitle,
            initialRoute: '/',
            debugShowCheckedModeBanner: false,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
      ),
    );
  }
}
