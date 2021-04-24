import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes/model/Languages.dart';
import 'package:notes/model/Note.dart';
import 'package:notes/widget/ModalSheetWidgets.dart';

class HomeNoteOptions extends StatefulWidget {
  const HomeNoteOptions({
    required this.note,
    required this.autoSaver,
    required this.saveNote,
    Key? key,
  }) : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  _HomeNoteOptionsState createState() => _HomeNoteOptionsState();
}

class _HomeNoteOptionsState extends State<HomeNoteOptions> {
  @override
  Widget build(BuildContext context) => Wrap(
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
                    ModalSheetHideWidget(
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
