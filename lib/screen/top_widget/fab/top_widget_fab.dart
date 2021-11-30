//25-11-2021 04:03 PM
import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

Widget? getFAB(final ScreenTypes topScreen, final BuildContext context) {
  switch (topScreen) {
    case ScreenTypes.hidden:
      return const Fab(
        onFabTap,
        noteState: NoteState.hidden,
      );
    case ScreenTypes.archive:
      return const Fab(
        onFabTap,
        noteState: NoteState.archived,
      );
    case ScreenTypes.trash:
      return const Fab(
        onTrashFabTap,
        icon: Icon(Icons.delete_forever_outlined),
      );
    case ScreenTypes.home:
      return const Fab(onFabTap);
    default:
      return null;
  }
}
