import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class BackUpScreen extends StatefulWidget {
  const BackUpScreen({
    final Key? key,
  }) : super(key: key);

  @override
  _BackUpScreenState createState() => _BackUpScreenState();
}

class _BackUpScreenState extends State<BackUpScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          /* SvgPicture.asset(
            backupSVG,
            height: 180,
          ),*/
          const SizedBox(
            height: 180,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 70),
            child: Text(
              Language.of(context).backupWarning,
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 40),
            child: ListTile(
              onTap: () {
                importFromFile().then((final value) {
                  showSnackbar(
                    context,
                    value
                        ? Language.of(context).done
                        : Language.of(context).error,
                    snackBarBehavior: SnackBarBehavior.floating,
                  );
                });
              },
              title: Text(Language.of(context).importNotes),
              leading: const Icon(Icons.notes_outlined),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ListTile(
              onTap: () {
                exportToFile().then((final value) {
                  showSnackbar(
                    context,
                    value
                        ? Language.of(context).done
                        : Language.of(context).error,
                    snackBarBehavior: SnackBarBehavior.floating,
                  );
                });
              },
              title: Text(Language.of(context).exportNotes),
              leading: const Icon(Icons.cloud_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
