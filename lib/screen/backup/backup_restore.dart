import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class BackUpScreen extends StatefulWidget {
  const BackUpScreen({final Key? key,}) : super(key: key);

  @override
  _BackUpScreenState createState() => _BackUpScreenState();
}

class _BackUpScreenState extends State<BackUpScreen>
    with TickerProviderStateMixin {
  ButtonState backupState = ButtonState.idle;
  ButtonState restoreState = ButtonState.idle;

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: SvgPicture.asset(backupSVG),
          ),
          const Divider(
            height: 20,
            color: Colors.transparent,
          ),
          Expanded(
              child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Text(
                '\t\t\t\t\t\t\t\t\t\t\t\tMake sure to unhide \t\t\t\t\t\t\t\teverything before backup',
                style: GoogleFonts.mcLaren(
                    textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),),
              ),
            ),
          ),),
          const Divider(
            height: 20,
            color: Colors.transparent,
          ),
          Expanded(
            child: ProgressButton.icon(
              radius: 30.0,
              minWidth: 100.0,
              maxWidth: 250.0,
              iconedButtons: {
                ButtonState.idle: IconedButton(
                    text: Language.of(context).backup,
                    icon: const Icon(Icons.send, color: Colors.white),
                    color: const Color(0xff37474F),),
                ButtonState.loading: IconedButton(
                    text: Language.of(context).waitWhileBackingup,
                    color: Colors.grey,),
                ButtonState.fail: IconedButton(
                    text: Language.of(context).error,
                    icon: const Icon(Icons.cancel, color: Colors.white),
                    color: Colors.redAccent,),
                ButtonState.success: IconedButton(
                    text: Language.of(context).done,
                    icon: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                    color: Theme.of(context).colorScheme.secondary,)
              },
              onPressed: onBackupTap,
              state: backupState,
            ),
          ),
          const Divider(
            height: 60,
            color: Colors.transparent,
          ),
          Expanded(
            child: ProgressButton.icon(
              radius: 30.0,
              minWidth: 100.0,
              maxWidth: 250.0,
              iconedButtons: {
                ButtonState.idle: IconedButton(
                    text: Language.of(context).restore,
                    icon: const Icon(Icons.send, color: Colors.white),
                    color: const Color(0xff37474F),),
                ButtonState.loading: IconedButton(
                    text: Language.of(context).waitWhileRestoring,
                    color: Colors.grey,),
                ButtonState.fail: IconedButton(
                    text: Language.of(context).error,
                    icon: const Icon(Icons.cancel, color: Colors.white),
                    color: Colors.redAccent,),
                ButtonState.success: IconedButton(
                    text: Language.of(context).done,
                    icon: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                    color: Theme.of(context).colorScheme.secondary,)
              },
              onPressed: onRestoreTap,
              state: restoreState,
            ),
          ),
          const Divider(
            height: 80,
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }

  Future<void> onBackupTap() async {
    await exportToFile().then((final value) {
      setState(() {
        if (value) {
          backupState = ButtonState.success;
        } else {
          backupState = ButtonState.fail;
        }
      });
      Future.delayed(const Duration(seconds: 120), () {
        setState(() {
          backupState = ButtonState.idle;
        });
      });
    });
  }

  Future<void> onRestoreTap() async {
    await importFromFile().then((final value) {
      setState(() {
        if (value) {
          restoreState = ButtonState.success;
        } else {
          restoreState = ButtonState.fail;
        }
      });
      Future.delayed(const Duration(seconds: 120), () {
        setState(() {
          restoreState = ButtonState.idle;
        });
      });
    });
  }
}
