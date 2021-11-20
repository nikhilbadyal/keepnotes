import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class HomeNoteOptions extends StatefulWidget {
  const HomeNoteOptions({
    required this.note,
    required this.autoSaver,
    required this.saveNote,
    final Key? key,
  }) : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  _HomeNoteOptionsState createState() => _HomeNoteOptionsState();
}

class _HomeNoteOptionsState extends State<HomeNoteOptions> {
  @override
  Widget build(final BuildContext context) => Wrap(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_outlined),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 16),
                Text(Language.of(context).options),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              children: [
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    ModalSheetWidget(
                      label: Language.of(context).hide,
                      icon: TablerIcons.ghost,
                      onTap: () {
                        Utilities.onModalHideTap(context, widget.note,
                            widget.autoSaver, widget.saveNote);
                      },
                    ),
                    ModalSheetWidget(
                      onTap: () {
                        Utilities.onModalArchiveTap(context, widget.note,
                            widget.autoSaver, widget.saveNote);
                      },
                      icon: Icons.archive_outlined,
                      label: Language.of(context).archive,
                    ),
                    ModalSheetWidget(
                      icon: TablerIcons.copy,
                      onTap: () {
                        Utilities.onModalCopyToClipboardTap(context,
                            widget.note, widget.autoSaver, widget.saveNote);
                      },
                      label: Language.of(context).clipboard,
                    ),
                    ModalSheetWidget(
                      icon: Icons.delete_outlined,
                      onTap: () async {
                        await Utilities.onModalTrashTap(context, widget.note,
                            widget.autoSaver, widget.saveNote);
                      },
                      label: Language.of(context).delete,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      );

  Future<void> onHideTap() async {
    final status =
        Provider.of<LockChecker>(context, listen: false).password.isNotEmpty;
    if (!status) {
      await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (final _) {
          return MyAlertDialog(
            title: Text(Language.of(context).setPasswordFirst),
            content: Container(),
          );
        },
      );
    } else {
      widget.autoSaver.cancel();
      widget.saveNote();
      final wantedRoute = getRoute(widget.note.state);
      await Utilities.onHideTap(context, widget.note);
      Navigator.of(context).popUntil(
        (final route) => route.settings.name == wantedRoute,
      );
    }
  }
}
