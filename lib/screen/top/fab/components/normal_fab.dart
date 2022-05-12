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
      padding: const EdgeInsets.only(bottom: 26),
      child: InkWell(
        onTap: () {
          HapticFeedback.vibrate();
          context.scaffold.openDrawer();
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
  context.sm.removeCurrentSnackBar();
  context.nextPage(
    AppRoutes.editScreen,
    arguments: emptyNote,
  );
}
