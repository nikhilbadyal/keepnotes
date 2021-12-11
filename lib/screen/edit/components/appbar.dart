import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class EditAppBar extends StatelessWidget with PreferredSizeWidget {
  const EditAppBar({
    required this.note,
    required this.saveNote,
    required this.autoSaverTimer,
    final Key? key,
  }) : super(key: key);

  final Note note;
  final Future<bool> Function() saveNote;
  final Timer autoSaverTimer;

  @override
  Widget build(final BuildContext context) {
    return AppBar(
      leading: BackButton(
        onPressed: () {
          autoSaverTimer.cancel();
          unawaited(
            saveNote().then((final value) {
              if (!value) {
                showSnackbar(context, Language.of(context).error);
              }
            }),
          );
          Navigator.of(context).pop();
        },
        color: Colors.white,
      ),
      actions: [
        Consumer<CharCount>(
          builder: (final _, final counter, final __) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(
                  right: 5.12 * widthMultiplier,
                ),
                child: Text(
                  counter.count.toString(),
                  style: GoogleFonts.merriweather(
                    textStyle: TextStyle(
                      fontSize: 2.35 * textMultiplier,
                      height: 1.7,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            );
          },
        )
      ],
      elevation: 1,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class CharCount extends ChangeNotifier {
  CharCount(this.count);

  int count;

  void setCount(final int length) {
    count = length;
    notifyListeners();
  }
}
