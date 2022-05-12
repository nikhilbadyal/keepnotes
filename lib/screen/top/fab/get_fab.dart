//25-11-2021 04:03 PM
import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

Widget? getFAB(final ScreenTypes topScreen, final BuildContext context) {
  switch (topScreen) {
    case ScreenTypes.hidden:
      return const Fab(noteState: NoteState.hidden, onFabTap: onFabTap);
    case ScreenTypes.archive:
      return const Fab(
        onFabTap: onFabTap,
        noteState: NoteState.archived,
      );
    case ScreenTypes.trash:
      return const TrashFab();
    case ScreenTypes.home:
      return const Fab(
        onFabTap: onFabTap,
      );
    default:
      return null;
  }
}
