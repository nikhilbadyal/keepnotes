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
  Future<void> saveNoteAndCancelTimer() async {
    widget.autoSaver.cancel();
    widget.saveNote();
    context.navigator.popUntil(
      ModalRoute.withName(widget.note.path),
    );
  }

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
                onPressed: context.previousPage,
              ),
              const SizedBox(width: 16),
              Text(context.language.options),
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
                    label: context.language.hide,
                    icon: TablerIcons.ghost,
                    onTap: () {
                      saveNoteAndCancelTimer();
                      unawaited(
                        ohHideTap(
                          context,
                          widget.note,
                        ),
                      );
                    },
                  ),
                  ModalSheetWidget(
                    label: context.language.unarchive,
                    onTap: () {
                      saveNoteAndCancelTimer();
                      unawaited(
                        context.noteHelper.unarchive(widget.note),
                      );
                    },
                    icon: Icons.unarchive_outlined,
                  ),
                  CopyToClipBoardModelSheetWidget(
                    widget.note,
                  ),
                  ModalSheetWidget(
                    icon: Icons.delete_outlined,
                    onTap: () {
                      saveNoteAndCancelTimer();
                      unawaited(
                        ohTrashTap(
                          context,
                          widget.note,
                        ),
                      );
                    },
                    label: context.language.delete,
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
