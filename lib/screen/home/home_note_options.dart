import 'package:notes/_aap_packages.dart';
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
  Widget build(final BuildContext context) {
    return Wrap(
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
          margin: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: Column(
            children: [
              Flex(
                direction: Axis.horizontal,
                children: [
                  ModalSheetWidget(
                    label: Language.of(context).hide,
                    icon: TablerIcons.ghost,
                    onTap: () {
                      ohHideTap(
                        widget.autoSaver,
                        widget.saveNote,
                        context,
                        widget.note,
                        isMounted: mounted,
                      );
                    },
                  ),
                  ModalSheetWidget(
                    onTap: () {
                      ohArchiveTap(
                        widget.autoSaver,
                        widget.saveNote,
                        context,
                        widget.note,
                        isMounted: mounted,
                      );
                    },
                    icon: Icons.archive_outlined,
                    label: Language.of(context).archive,
                  ),
                  CopyToClipBoardModelSheetWidget(
                    widget.autoSaver,
                    widget.saveNote,
                    widget.note,
                  ),
                  ModalSheetWidget(
                    icon: Icons.delete_outlined,
                    onTap: () {
                      ohTrashTap(
                        widget.autoSaver,
                        widget.saveNote,
                        context,
                        widget.note,
                        isMounted: mounted,
                      );
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
  }
}
