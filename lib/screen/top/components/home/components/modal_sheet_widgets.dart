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
  State<HomeNoteOptions> createState() => _HomeNoteOptionsState();
}

class _HomeNoteOptionsState extends State<HomeNoteOptions> {
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
                icon: const Icon(Icons.arrow_back_outlined),
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
                    onTap: () {
                      saveNoteAndCancelTimer();
                      unawaited(
                        ohArchiveTap(
                          context,
                          widget.note,
                        ),
                      );
                    },
                    icon: Icons.archive_outlined,
                    label: context.language.archive,
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
