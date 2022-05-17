import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

class BottomBarOptions extends StatefulWidget {
  const BottomBarOptions({
    required this.note,
    required this.autoSaver,
    required this.saveNote,
    final Key? key,
  }) : super(key: key);
  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  State<BottomBarOptions> createState() => _BottomBarOptionsState();
}

class _BottomBarOptionsState extends State<BottomBarOptions>
    with TickerProviderStateMixin {
  @override
  Widget build(final BuildContext context) => AnimatedSize(
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: bottomSheetTimer),
        child: Column(
          children: [
            _currentOptionWidget(),
            Container(
              height: context.mq.padding.bottom,
              color: context.canvasColor,
            )
          ],
        ),
      );

  Widget _currentOptionWidget() {
    switch (widget.note.state) {
      case NoteState.unspecified:
        return HomeNoteOptions(
          note: widget.note,
          saveNote: widget.saveNote,
          autoSaver: widget.autoSaver,
        );

      case NoteState.archived:
        return ArchiveNoteOptions(
          note: widget.note,
          saveNote: widget.saveNote,
          autoSaver: widget.autoSaver,
        );

      case NoteState.hidden:
        return HiddenNoteOptions(
          note: widget.note,
          saveNote: widget.saveNote,
          autoSaver: widget.autoSaver,
        );

      default:
        return const ErrorModalSheet();
    }
  }
}
