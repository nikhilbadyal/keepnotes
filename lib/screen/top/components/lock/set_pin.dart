import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class SetPassword extends StatefulWidget {
  const SetPassword({
    final Key? key,
  }) : super(key: key);

  @override
  _SetPasswordState createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  String enteredPassCode = '';
  late DataObj args;

  Future<void> doneEnteringPass(final String enteredPassCode) async {
    if (args.isFirst) {
      await Future.delayed(
        const Duration(milliseconds: pinEnterReset),
      );
      if (!mounted) {
        return;
      }
      await navigate(
        context.modalRouteSettingName(),
        context,
        AppRoutes.setPassScreen,
        DataObj(
          enteredPassCode,
          context.language.reEnterPassword,
          resetPass: args.resetPass,
          isFirst: false,
        ),
      );
    } else {
      if (enteredPassCode == args.firstPass) {
        if (args.resetPass) {
          if (Provider.of<AppConfiguration>(context, listen: false).password ==
              enteredPassCode) {
            showSnackbar(
              context,
              context.language.samePasswordError,
            );
          } else {
            await Provider.of<AppConfiguration>(context, listen: false)
                .passwordSetConfig(enteredPassCode);
          }
          await Future.delayed(
            const Duration(milliseconds: pinEnterReset),
          );
          if (!mounted) {
            return;
          }
          context.nextReplacementPage(AppRoutes.settingsScreen);
          return;
        } else {
          unawaited(
            Provider.of<AppConfiguration>(context, listen: false)
                .passwordSetConfig(enteredPassCode),
          );
          showSnackbar(
            context,
            context.language.done,
          );
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
        }
      } else {
        showSnackbar(
          context,
          context.language.passwordNotMatch,
        );
        await Future.delayed(
          const Duration(milliseconds: pinEnterReset),
        );
        if (!mounted) {
          return;
        }

        await navigate(
          context.modalRouteSettingName(),
          context,
          AppRoutes.setPassScreen,
          DataObj(
            '',
            context.language.enterNewPassword,
            isFirst: true,
          ),
        );
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    args = context.modalRouteArguments() as DataObj;
    return LockBody(
      title: args.heading,
      doneCallBack: doneEnteringPass,
    );
  }
}

class DataObj {
  DataObj(
    this.firstPass,
    this.heading, {
    required this.isFirst,
    this.resetPass = false,
  });

  final String firstPass;
  final String heading;
  final bool isFirst;
  final bool resetPass;
}
