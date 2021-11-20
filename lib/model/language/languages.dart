import 'package:notes/_app_packages.dart';
import 'package:notes/_internal_packages.dart';

final supportedLanguages = <LanguageData>[
  LanguageData('🇺🇸', 'English', 'en'),
  LanguageData('in', 'Hindi', 'hi'),
];

class LanguageData {
  LanguageData(this.flag, this.name, this.languageCode);

  final String flag;
  final String name;
  final String languageCode;
}

Future<Language> _loadLocale(final Locale locale) async {
  switch (locale.languageCode) {
    case 'en':
      return LanguageEn();
    case 'hi':
      return LanguageHi();
    default:
      return LanguageEn();
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<Language> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(final Locale locale) {
    final supportedLanguageCodes = <String>[];
    for (final element in supportedLanguages) {
      supportedLanguageCodes.add(element.languageCode);
    }
    return supportedLanguageCodes.contains(locale.languageCode);
  }

  @override
  Future<Language> load(final Locale locale) => _loadLocale(locale);

  @override
  bool shouldReload(final LocalizationsDelegate<Language> old) => false;
}

class FallbackLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  @override
  bool isSupported(final Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(final Locale locale) async =>
      const DefaultMaterialLocalizations();

  @override
  bool shouldReload(
          covariant final LocalizationsDelegate<MaterialLocalizations> old) =>
      false;
}

abstract class Language {
  String get appTagLine;

  String get loginToContinue;

  String get forgotPassword;

  String get login;

  String get createNewAccount;

  String get backToLogin;

  String get signUp;

  String get accountAlreadyExist;

  String get emailAlreadyExist;

  String get invalidEmail;

  String get verifyEmail;

  String get weakPassword;

  String get tryAgainLater; // We keep you safe
  String get contactUs;

  String get unableToLaunchEmail;

  String get tapMe;

  String get on; // We keep you safe
  String get off; // We keep you safe

  String get getStarted;

  String get soon;

  String get good;

  String get morning;

  String get afternoon;

  String get night;

  String get labelLanguage => 'Languages';

  String get samePasswordError;

  String get removeBiometric;

  String get areYouSure;

  String get general;

  String get security;

  String get ui;

  String get insufficientData;

  String get localizedReason;

  String get hello;

  String get there;

  String get enterPassword;

  String get enterNewPassword;

  String get wrongPassword;

  String get clipboard;

  String get hide;

  String get unarchive;

  String get emptyTrash;

  String get emptyTrashWarning;

  String get unhide;

  String get reEnterPassword;

  String get passwordNotMatch;

  String get changePassword;

  String get resetPassword;

  String get primaryColor;

  String get accentColor;

  String get logOut;

  String get darkMode;

  String get directBio;

  String get directDelete;

  String get pickColor;

  String get done;

  String get backupWarning;

  String get viewMore;

  String get delete;

  String get deleteNotePermanently;

  String get deleteAllNotesResetPassword;

  String get restore;

  String get copy;

  String get trash;

  String get setPassAndHideAgain;

  String get passwordReset;

  String get reset;

  String get trashEditingWarning;

  String get doubleBackToExit;

  String get reportSuggest;

  String get nothingHere;

  String get tapOn;

  String get toAddNewNote;

  String get noColor;

  String get randomColor;

  String get appColor;

  String get notAvailJustification;

  String get alreadyDone;

  String get doItForMe;

  String get setPasswordFirst;

  String get appTitle;

  String get home;

  String get hidden;

  String get archive;

  String get backup;

  String get about;

  String get settings;

  String get name;

  String get devName;

  String get email;

  String get social;

  String get options;

  String get backupScheduled;

  String get exportNotes;

  String get importNotes;

  String get permissionError;

  String get enterNoteTitle;

  String get enterNoteContent;

  String get modified;

  String get emptyNote;

  String get more;

  String get emptyNoteDiscarded;

  String get error;

  String get enterPasswordOnce;

  String get setFpFirst;

  String get alertDialogOp1;

  String get alertDialogOp2;

  String get checkEmail;

  String get required;

  static Language of(final BuildContext context) =>
      Localizations.of<Language>(context, Language) ?? LanguageEn();
}

const String prefSelectedLanguageCode = 'SelectedLanguageCode';

Future<Locale> setLocale(final String languageCode) async {
  await addStringToSF('appLocale', languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  late String languageCode;
  try {
    languageCode = getStringFromSF('appLocale') ?? 'en';
  } on Exception catch (_) {
    return _locale('en');
  }
  return _locale(languageCode);
}

Locale _locale(final String languageCode) =>
    languageCode.isNotEmpty ? Locale(languageCode, '') : const Locale('en', '');

Future<void> changeLanguage(
    final BuildContext context, final String selectedLanguageCode) async {
  final _locale = await setLocale(selectedLanguageCode);
  MyNotes.setLocale(context, _locale);
}
