import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class CopyToClipBoardModelSheetWidget extends StatelessWidget {
  const CopyToClipBoardModelSheetWidget(
    this.note, {
    final Key? key,
  }) : super(key: key);
  final Note note;

  @override
  Widget build(final BuildContext context) {
    return ModalSheetWidget(
      icon: TablerIcons.copy,
      onTap: () {
        context.previousPage();
        unawaited(
          Clipboard.setData(
            ClipboardData(text: note.title),
          ).then((final _) {
            Clipboard.setData(
              ClipboardData(text: note.content),
            ).then(
              (final value) => showSnackbar(
                context,
                Language.of(context).done,
                snackBarBehavior: SnackBarBehavior.floating,
              ),
            );
          }),
        );
      },
      label: Language.of(context).clipboard,
    );
  }
}
