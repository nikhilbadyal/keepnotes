import 'package:notes/_app_packages.dart';
import 'package:notes/_internal_packages.dart';

typedef OnFabTap = Future<void> Function(
    BuildContext context, NoteState noteState);

class Fab extends StatelessWidget {
  const Fab(OnFabTap this.onFabTap,
      {this.noteState = NoteState.unspecified,
      this.icon = const Icon(
        Icons.add,
        size: 30,
      ),
      Key? key})
      : super(key: key);

  final Function(BuildContext context, NoteState noteState) onFabTap;

  final NoteState noteState;

  final Icon icon;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: GestureDetector(
          onLongPress: () {
            HapticFeedback.vibrate();
            Scaffold.of(context).openDrawer();
          },
          child: FloatingActionButton(
            onPressed: () => onFabTap(context, noteState),
            child: icon,
          ),
        ),
      );
}

class SelectDeSelectAllFab extends StatelessWidget {
  const SelectDeSelectAllFab({Key? key}) : super(key: key);

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
