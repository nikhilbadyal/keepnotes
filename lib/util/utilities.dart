import 'package:notes/_aap_packages.dart';
// ignore_for_file: use_build_context_synchronously
//TODO fix this
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';
import 'package:url_launcher/url_launcher_string.dart';

late SharedPreferences prefs;

Future<bool> urlLauncher(final String url) async {
  if (await canLaunchUrlString(url)) {
    return launchUrlString(url);
  } else {
    return false;
  }
}

void showSnackbar(
  final BuildContext context,
  final String data, {
  final Duration duration = const Duration(seconds: snackBarDuration),
  final SnackBarAction? action,
  final SnackBarBehavior? snackBarBehavior,
}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    _getSnackBar(
      data,
      duration: duration,
      snackBarBehavior: snackBarBehavior,
      action: action,
    ),
  );
}

SnackBar _getSnackBar(
  final String data, {
  required final Duration duration,
  final SnackBarAction? action,
  final SnackBarBehavior? snackBarBehavior,
}) {
  return SnackBar(
    key: UniqueKey(),
    content: Text(
      data,
    ),
    action: action,
    duration: duration,
    behavior: snackBarBehavior,
  );
}

String initialize(final User? curUser) {
  encryption = Encrypt(curUser!.uid);
  FirebaseDatabaseHelper(curUser.uid);
  return encryption.decryptStr(getStringFromSF('password') ?? '');
}

Future<void> ohHideTap(
  final BuildContext context,
  final Note note,
) async {
  final status =
      Provider.of<AppConfiguration>(context, listen: false).password.isNotEmpty;
  if (!status) {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (final context) => MyAlertDialog(
        content: Text(
          Language.of(context).setPasswordFirst,
        ),
      ),
    );
  } else {
    await Provider.of<NotesHelper>(context, listen: false).hide(note);
  }
}

Future<void> ohTrashTap(
  final BuildContext context,
  final Note note,
) async {
  Navigator.of(context).popUntil(
    ModalRoute.withName(note.path),
  );
  await Provider.of<NotesHelper>(context, listen: false).trash(note);
}

Future<void> ohArchiveTap(
  final BuildContext context,
  final Note note,
) async {
  await Provider.of<NotesHelper>(context, listen: false).trash(note);
}

void hideKeyboard(final BuildContext context) {
  final currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}
