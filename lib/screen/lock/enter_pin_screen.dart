import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({
    final Key? key,
  }) : super(key: key);

  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  bool args = false;

  Future<void> onFingerTap() async {
    await HapticFeedback.vibrate();
    if (getBoolFromSF('bio') ?? false) {
      if (getBoolFromSF('firstTimeNeeded') ?? false) {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (final context) => MyAlertDialog(
            content: Text(Language.of(context).enterPasswordOnce),
          ),
        );
      } else {
        if (!mounted) {
          return;
        }

        final status =
            await Provider.of<AppConfiguration>(context, listen: false)
                .authenticate(Language.of(context).localizedReason);
        if (status) {
          if (!mounted) {
            return;
          }

          await navigate(
            ModalRoute.of(context)!.settings.name!,
            context,
            AppRoutes.hiddenScreen,
          );
        }
      }
    } else {
      final isAuthenticated = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (final context) => MyAlertDialog(
              content: Text(Language.of(context).setFpFirst),
              actions: [
                TextButton(
                  onPressed: () async {
                    final status = await Provider.of<AppConfiguration>(
                      context,
                      listen: false,
                    ).authenticate(Language.of(context).localizedReason);
                    if (!mounted) {
                      return;
                    }

                    Navigator.of(context).pop(status);
                  },
                  child: Text(
                    Language.of(context).alertDialogOp1,
                    style: TextStyle(
                      fontSize: 2.35 * textMultiplier,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    Language.of(context).alertDialogOp2,
                    style: TextStyle(
                      fontSize: 2.35 * textMultiplier,
                    ),
                  ),
                ),
              ],
            ),
          ) ??
          false;
      if (isAuthenticated) {
        if (!mounted) {
          return;
        }
        await Provider.of<AppConfiguration>(context, listen: false)
            .bioEnabledConfig();
      }
    }
  }

  Future<void> doneEnteringPass(final String enteredPassCode) async {
    if (enteredPassCode ==
        Provider.of<AppConfiguration>(context, listen: false).password) {
      final bioEnable = getBoolFromSF('bio') ?? false;
      final firstTime = getBoolFromSF('firstTimeNeeded') ?? false;
      if (bioEnable && firstTime) {
        await addBoolToSF('firstTimeNeeded', value: false);
      }
      await Future.delayed(
        const Duration(milliseconds: pinEnterReset),
      );
      if (!mounted) {
        return;
      }
      await navigate(
        ModalRoute.of(context)!.settings.name!,
        context,
        AppRoutes.hiddenScreen,
      );
    } else {
      showSnackbar(
        context,
        Language.of(context).wrongPassword,
      );
    }
  }

  Future<void> newPassDone(final String enteredPassCode) async {
    if (enteredPassCode ==
        Provider.of<AppConfiguration>(context, listen: false).password) {
      await navigate(
        ModalRoute.of(context)!.settings.name!,
        context,
        AppRoutes.setPassScreen,
        DataObj(
          '',
          Language.of(context).enterNewPassword,
          resetPass: true,
          isFirst: true,
        ),
      );
    } else {
      showSnackbar(
        context,
        Language.of(context).wrongPassword,
      );
    }
  }

  @override
  Widget build(final BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments! as bool;
    return LockBody(
      title: Language.of(context).enterPassword,
      doneCallBack: args ? newPassDone : doneEnteringPass,
      onFingerTap: args ? null : onFingerTap,
    );
  }
}
