import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({
    final Key? key,
  }) : super(key: key);

  @override
  State<LockScreen> createState() => _LockScreenState();
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
            content: Text(context.language.enterPasswordOnce),
          ),
        );
      } else {
        if (!mounted) {
          return;
        }

        final status = await context.appConfig
            .authenticate(context.language.localizedReason);
        if (status) {
          if (!mounted) {
            return;
          }

          await navigate(
            context.modalRouteSettingName(),
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
              content: Text(context.language.setFpFirst),
              actions: [
                TextButton(
                  onPressed: () async {
                    final status = await context.appConfig.authenticate(
                      context.language.localizedReason,
                    );
                    if (!mounted) {
                      return;
                    }
                    context.previousPage(status);
                  },
                  child: Text(
                    context.language.alertDialogOp1,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.previousPage(false),
                  child: Text(
                    context.language.alertDialogOp2,
                    style: const TextStyle(
                      fontSize: 20,
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
        await context.appConfig.bioEnabledConfig();
      }
    }
  }

  Future<void> doneEnteringPass(final String enteredPassCode) async {
    if (enteredPassCode == context.appConfig.password) {
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
        context.modalRouteSettingName(),
        context,
        AppRoutes.hiddenScreen,
      );
    } else {
      showSnackbar(
        context,
        context.language.wrongPassword,
      );
    }
  }

  Future<void> newPassDone(final String enteredPassCode) async {
    if (enteredPassCode == context.appConfig.password) {
      await navigate(
        context.modalRouteSettingName(),
        context,
        AppRoutes.setPassScreen,
        DataObj(
          '',
          context.language.enterNewPassword,
          resetPass: true,
          isFirst: true,
        ),
      );
    } else {
      showSnackbar(
        context,
        context.language.wrongPassword,
      );
    }
  }

  @override
  Widget build(final BuildContext context) {
    args = context.modalRouteArguments() as bool;
    return LockBody(
      title: context.language.enterPassword,
      doneCallBack: args ? newPassDone : doneEnteringPass,
      onFingerTap: args ? null : onFingerTap,
    );
  }
}
