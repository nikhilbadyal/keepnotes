import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class ArchiveNoteOptions extends StatefulWidget {
  const ArchiveNoteOptions({
    required this.note,
    required this.autoSaver,
    required this.saveNote,
    final Key? key,
  }) : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  _ArchiveNoteOptionsState createState() => _ArchiveNoteOptionsState();
}

class _ArchiveNoteOptionsState extends State<ArchiveNoteOptions> {
  @override
  Widget build(final BuildContext context) {
    return Wrap(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_outlined,
                ),
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
                      onModalHideTap(context, widget.note, widget.autoSaver,
                          widget.saveNote);
                    },
                  ),
                  ModalSheetWidget(
                    label: Language.of(context).unarchive,
                    onTap: () {
                      onModalUnArchiveTap(context, widget.note,
                          widget.autoSaver, widget.saveNote);
                    },
                    icon: Icons.unarchive_outlined,
                  ),
                  ModalSheetWidget(
                    icon: TablerIcons.copy,
                    onTap: () {
                      onModalCopyToClipboardTap(context, widget.note,
                          widget.autoSaver, widget.saveNote);
                    },
                    label: Language.of(context).clipboard,
                  ),
                  ModalSheetWidget(
                    icon: Icons.delete_outlined,
                    onTap: () async {
                      await onModalTrashTap(context, widget.note,
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
  }
}
