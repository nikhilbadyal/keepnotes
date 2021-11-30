import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class SetPassword extends StatefulWidget {
  const SetPassword({final Key? key}) : super(key: key);

  @override
  _SetPasswordState createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  String enteredPassCode = '';
  late DataObj args;

  Future<void> doneEnteringPass(final String enteredPassCode) async {
    if (args.isFirst) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) {
        return;
      }
      await navigate(
        ModalRoute.of(context)!.settings.name!,
        context,
        AppRoutes.setPassScreen,
        DataObj(enteredPassCode, Language.of(context).reEnterPassword,
            resetPass: args.resetPass, isFirst: false),
      );
    } else {
      if (enteredPassCode == args.firstPass) {
        if (args.resetPass) {
          if (Provider.of<AppConfiguration>(context, listen: false).password ==
              enteredPassCode) {
            showSnackbar(
              context,
              Language.of(context).samePasswordError,
              duration: const Duration(milliseconds: 1500),
            );
          } else {
            await Provider.of<AppConfiguration>(context, listen: false)
                .passwordSetConfig(enteredPassCode);
          }
          await Future.delayed(const Duration(milliseconds: 500));
          if (!mounted) {
            return;
          }

          await Navigator.of(context)
              .pushReplacementNamed(AppRoutes.settingsScreen);
          return;
        } else {
          unawaited(Provider.of<AppConfiguration>(context, listen: false)
              .passwordSetConfig(enteredPassCode));
          showSnackbar(
            context,
            Language.of(context).done,
          );
          await Future.delayed(const Duration(milliseconds: 500));
          if (!mounted) {
            return;
          }

          await navigate(ModalRoute.of(context)!.settings.name!, context,
              AppRoutes.hiddenScreen);
        }
      } else {
        showSnackbar(
          context,
          Language.of(context).passwordNotMatch,
        );
        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) {
          return;
        }

        await navigate(
          ModalRoute.of(context)!.settings.name!,
          context,
          AppRoutes.setPassScreen,
          DataObj(
            '',
            Language.of(context).enterNewPassword,
            isFirst: true,
          ),
        );
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments! as DataObj;
    return LockBody(
      title: args.heading,
      doneCallBack: doneEnteringPass,
    );
  }
}

class DataObj {
  DataObj(this.firstPass, this.heading,
      {required this.isFirst, this.resetPass = false});

  final String firstPass;
  final String heading;
  final bool isFirst;
  final bool resetPass;
}
