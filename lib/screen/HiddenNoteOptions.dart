import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes/model/Note.dart';
import 'package:notes/screen/ModalSheetWidgets.dart';

class HiddenNoteOptions extends StatefulWidget {
  const HiddenNoteOptions(
      {Key? key,
      required this.note,
      required this.autoSaver,
      required this.saveNote})
      : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  _HiddenNoteOptionsState createState() => _HiddenNoteOptionsState();
}

class _HiddenNoteOptionsState extends State<HiddenNoteOptions> {
  @override
  Widget build(BuildContext context) {
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
              const Text('Options'),
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
                  ModalSheetUnhideWidget(
                    note: widget.note,
                    saveNote: widget.saveNote,
                    autoSaver: widget.autoSaver,
                  ),
                  ModalSheetArchiveWidget(
                    note: widget.note,
                    saveNote: widget.saveNote,
                    autoSaver: widget.autoSaver,
                  ),
                  ModalSheetCopyToClipBoardWidget(
                    note: widget.note,
                    saveNote: widget.saveNote,
                    autoSaver: widget.autoSaver,
                  ),
                  ModalSheetTrashWidget(
                    note: widget.note,
                    saveNote: widget.saveNote,
                    autoSaver: widget.autoSaver,
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
