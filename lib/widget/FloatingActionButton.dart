import 'package:flutter/material.dart';
import 'package:notes/model/Note.dart';
import 'package:notes/widget/HomeBody.dart';

class Fab extends StatelessWidget {
  const Fab(
      Future<void> Function(BuildContext context, NoteState noteState)
          this.onFabTap,
      {this.noteState = NoteState.unspecified,
      this.icon = const Icon(Icons.add)});

  final Function(BuildContext context, NoteState noteState) onFabTap;

  final NoteState noteState;

  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: GestureDetector(
        onLongPress: () => Scaffold.of(context).openDrawer(),
        child: FloatingActionButton(
          onPressed: () => onFabTap(context, noteState),
          child: icon,
        ),
      ),
    );
  }
}

class SelectDeSelectAllFab extends StatelessWidget {
  const SelectDeSelectAllFab();

  @override
  Widget build(BuildContext context) {
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
