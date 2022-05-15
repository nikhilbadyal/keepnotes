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
  context.sm.removeCurrentSnackBar();
  context.sm.showSnackBar(
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
  FirebaseHelper(curUser.uid);
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
          context.language.setPasswordFirst,
        ),
      ),
    );
  } else {
    await context.noteHelper.hide(note);
  }
}

Future<void> ohTrashTap(
  final BuildContext context,
  final Note note,
) async {
  await context.noteHelper.trash(note);
}

Future<void> ohArchiveTap(
  final BuildContext context,
  final Note note,
) async {
  await context.noteHelper.trash(note);
}

void hideKeyboard(final BuildContext context) {
  if (!context.focus.hasPrimaryFocus) {
    context.focus.unfocus();
  }
}
