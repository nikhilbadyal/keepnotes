import 'package:flutter/material.dart';
import 'package:notes/model/note.dart';
import 'package:notes/util/Navigations.dart';
import 'package:notes/widget/BottomSheet.dart';
import 'package:notes/widget/HomeBody.dart';

class Fab extends StatelessWidget {
  const Fab(this.noteState);

  final NoteState noteState;

  @override
  Widget build(BuildContext context) {
    //debugPrint('FAB building 35');
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: GestureDetector(
        onLongPress: () => Scaffold.of(context).openDrawer(),
        child: FloatingActionButton(
          onPressed: () async {
            final emptyNote = Note(
              title: '',
              content: '',
              lastModify: DateTime.now(),
              state: noteState,
            );
            await goToNoteEditScreen(
                context: context, note: emptyNote, shouldAutoFocus: true);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class TrashFab extends StatelessWidget {
  const TrashFab();

  @override
  Widget build(BuildContext context) {
    //debugPrint('FAB building 35');
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: FloatingActionButton(
        onPressed: () async {
          moreOptions(context);
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.delete_forever_outlined),
      ),
    );
  }
}

class SelectDeSelectAllFab extends StatelessWidget {
  const SelectDeSelectAllFab();

  @override
  Widget build(BuildContext context) {
    //debugPrint('FAB building 35');
    final isFalseAvailable = homeBody!.selectedFlag.containsValue(false);
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: FloatingActionButton(
        onPressed: _selectAll,
        child: Icon(
          isFalseAvailable ? Icons.done_all : Icons.remove_done,
        ),
      ),
    );
  }

  void _selectAll() {
    final isFalseAvailable = homeBody!.selectedFlag.containsValue(false);
    homeBody!.selectedFlag.updateAll((key, value) => isFalseAvailable);
    homeBody!.isSelectionMode = homeBody!.selectedFlag.containsValue(true);
    homeBody!.callSetState();
  }
}
