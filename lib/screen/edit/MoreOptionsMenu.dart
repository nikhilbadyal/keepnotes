import 'package:flutter/material.dart';
import 'package:notes/_internalPackages.dart';
import 'package:notes/model/_model.dart';
import 'package:notes/screen/_screens.dart';

class MoreOptionsMenu extends StatefulWidget {
  const MoreOptionsMenu({
    required this.note,
    required this.autoSaver,
    required this.saveNote,
    Key? key,
  }) : super(key: key);
  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  _MoreOptionsMenuState createState() => _MoreOptionsMenuState();
}

class _MoreOptionsMenuState extends State<MoreOptionsMenu>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) => AnimatedSize(
        vsync: this,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 200),
        child: Column(
          children: [
            _currentOptionWidget(),
            Container(
                height: MediaQuery.of(context).padding.bottom,
                color: Theme.of(context).cardColor)
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
