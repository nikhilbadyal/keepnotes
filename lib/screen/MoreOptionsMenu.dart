import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes/model/note.dart';
import 'package:notes/screen/ArchiveNoteOptions.dart';
import 'package:notes/screen/ErrorModelSheet.dart';
import 'package:notes/screen/HiddenNoteOptions.dart';
import 'package:notes/screen/UnspecifiedNoteOptions.dart';

class MoreOptionsMenu extends StatefulWidget {
  const MoreOptionsMenu(
      {Key? key,
      required this.note,
      required this.autoSaver,
      required this.saveNote})
      : super(key: key);
  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  _MoreOptionsMenuState createState() => _MoreOptionsMenuState();
}

class _MoreOptionsMenuState extends State<MoreOptionsMenu>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
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
  }

  Widget _currentOptionWidget() {
    switch (widget.note.state) {
      case NoteState.unspecified:
        return UnspecifiedNoteOptions(
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
        return ErrorModalSheet();
    }
  }
}
