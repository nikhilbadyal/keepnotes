import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

class EditAppBar extends StatelessWidget with PreferredSizeWidget {
  const EditAppBar(
      {required this.note,
      required this.saveNote,
      required this.autoSaverTimer,
      final Key? key})
      : super(key: key);

  final Note note;
  final Future<bool> Function() saveNote;
  final Timer autoSaverTimer;

  @override
  Widget build(final BuildContext context) {
    return AppBar(
      leading: BackButton(
        onPressed: () {
          autoSaverTimer.cancel();
          unawaited(saveNote().then((final value) {
            if (!value) {
              showSnackbar(context, Language.of(context).error);
            }
          }));
          Navigator.of(context).pop();
        },
        color: Colors.white,
      ),
      actions: [
        IconButton(
          onPressed: () async {
            if (note.title.isEmpty && note.content.isEmpty) {
              showSnackbar(context, Language.of(context).emptyNote);
              return;
            }
          },
          icon: const Icon(Icons.print),
        ),
      ],
      elevation: 1,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
