import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class Fab extends StatelessWidget {
  const Fab(OnFabTap this.onFabTap,
      {this.noteState = NoteState.unspecified,
      this.icon = const Icon(
        Icons.add,
        size: 30,
      ),
      final Key? key})
      : super(key: key);

  final Function(BuildContext context, NoteState noteState) onFabTap;

  final NoteState noteState;

  final Icon icon;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: GestureDetector(
        onTap: () {
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
}

void onTrashFabTap(final BuildContext context, final NoteState _) {
  moreOptions(context);
}

Future<void> onFabTap(
    final BuildContext context, final NoteState noteState) async {
  final emptyNote = Note(
    id: const Uuid().v4(),
    lastModify: DateTime.now(),
    state: noteState,
  );
  await goToNoteEditScreen(
      context: context, note: emptyNote, shouldAutoFocus: true);
}
