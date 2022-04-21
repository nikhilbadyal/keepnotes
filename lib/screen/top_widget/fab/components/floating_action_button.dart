import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class Fab extends StatelessWidget {
  const Fab({
    required OnFabTap this.onFabTap,
    this.noteState = NoteState.unspecified,
    this.icon,
    final Key? key,
  }) : super(key: key);

  final Function(BuildContext context, NoteState noteState) onFabTap;

  final NoteState noteState;

  final Icon? icon;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.94 * heightMultiplier),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.vibrate();
          Scaffold.of(context).openDrawer();
        },
        child: FloatingActionButton(
          onPressed: () => onFabTap(context, noteState),
          child: icon ?? addIcon,
        ),
      ),
    );
  }
}

Future<void> onFabTap(
  final BuildContext context,
  final NoteState noteState,
) async {
  final emptyNote = NoteX.emptyNote.copyWith(
    id: const Uuid().v4(),
    lastModify: DateTime.now(),
    state: noteState,
  );
  ScaffoldMessenger.of(context).removeCurrentSnackBar();

  await Navigator.pushNamed(
    context,
    AppRoutes.editScreen,
    arguments: emptyNote,
  );
}
