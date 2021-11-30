import 'package:notes/_aap_packages.dart';

// ignore_for_file: use_build_context_synchronously
//TODO fix this
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

late SharedPreferences prefs;

Future<bool> launchUrl(final String url) async {
  if (await canLaunch(url)) {
    return launch(url);
  } else {
    return false;
  }
}

SnackBarAction resetAction(final BuildContext context) {
  return SnackBarAction(
    label: Language.of(context).reset,
    onPressed: () async {
      await showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (final context) => Center(
          child: SingleChildScrollView(
            child: MyAlertDialog(
              content: Text(Language.of(context).deleteAllNotesResetPassword),
              actions: [
                TextButton(
                  onPressed: () async {
                    await Provider.of<NotesHelper>(context, listen: false)
                        .deleteAllHidden();
                    showSnackbar(
                      context,
                      Language.of(context).passwordReset,
                    );
                    await Provider.of<AppConfiguration>(context, listen: false)
                        .resetConfig();
                    await navigate('', context, AppRoutes.homeScreen);
                    Navigator.of(context).pop(true);
                  },
                  child: Text(Language.of(context).alertDialogOp1),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(Language.of(context).alertDialogOp2),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void showSnackbar(final BuildContext context, final String data,
    {final Duration duration = const Duration(seconds: 2),
    final SnackBarAction? action,
    final SnackBarBehavior? snackBarBehavior}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    _getSnackBar(context, data,
        duration: duration, snackBarBehavior: snackBarBehavior, action: action),
  );
}

SnackBar _getSnackBar(final BuildContext context, final String data,
        {final Duration duration = const Duration(seconds: 1),
        final SnackBarAction? action,
        final SnackBarBehavior? snackBarBehavior}) =>
    SnackBar(
      key: UniqueKey(),
      content: Text(
        data,
      ),
      action: action,
      duration: duration,
      behavior: snackBarBehavior,
    );

Future<void> onHideTap(final BuildContext context, final Note note) async {
  final status =
      Provider.of<AppConfiguration>(context, listen: false).password.isNotEmpty;
  if (!status) {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (final context) => MyAlertDialog(
        content: Text(Language.of(context).setPasswordFirst),
      ),
    );
  } else {
    await Provider.of<NotesHelper>(context, listen: false).hide(note);
  }
}

Future<bool> onDeleteTap(final BuildContext context, final Note note,
    {final bool deleteDirectly = true}) async {
  var choice = true;
  if (!deleteDirectly) {
    choice = await showDialog<bool>(
          barrierDismissible: false,
          context: context,
          builder: (final context) => MyAlertDialog(
            content: Text(Language.of(context).deleteNotePermanently),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(Language.of(context).alertDialogOp1),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(Language.of(context).alertDialogOp2),
              )
            ],
          ),
        ) ??
        false;
  }
  return choice;
}

String initialize(final User? curUser) {
  encryption = Encrypt(curUser!.uid);
  FirebaseDatabaseHelper(curUser.uid);
  return encryption.decryptStr(getStringFromSF('password') ?? '');
}
