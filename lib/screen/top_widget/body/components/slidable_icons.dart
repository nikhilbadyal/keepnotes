//30-11-2021 03:05 PM

import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

Widget hideAction(
    final String label, final Color foregroundColor, final Note note) {
  return SlidableAction(
    autoClose: false,
    icon: TablerIcons.ghost,
    label: label,
    backgroundColor: Colors.transparent,
    foregroundColor: foregroundColor,
    onPressed: (final context) => onHideTap(context, note),
  );
}

Widget deleteAction(
    final String label, final Color foregroundColor, final Note note,
    {final bool shouldAsk = true}) {
  return SlidableAction(
    autoClose: false,
    icon: Icons.delete_forever_outlined,
    label: label,
    backgroundColor: Colors.transparent,
    foregroundColor: foregroundColor,
    onPressed: (final context) {
      onDeleteTap(context, note, deleteDirectly: shouldAsk).then((final value) {
        if (value) {
          unawaited(Provider.of<NotesHelper>(context, listen: false)
              .delete(note)
              .then((final value) {}));
        }
      });
    },
  );
}

Widget trashAction(
    final String label, final Color foregroundColor, final Note note) {
  return SlidableAction(
    autoClose: false,
    icon: Icons.delete_outline,
    label: label,
    backgroundColor: Colors.transparent,
    foregroundColor: foregroundColor,
    onPressed: (final context) =>
        unawaited(Provider.of<NotesHelper>(context, listen: false).trash(note)),
  );
}

Widget copyAction(
    final String label, final Color foregroundColor, final Note note) {
  return SlidableAction(
    autoClose: false,
    icon: TablerIcons.copy,
    label: label,
    backgroundColor: Colors.transparent,
    foregroundColor: foregroundColor,
    onPressed: (final context) =>
        unawaited(Provider.of<NotesHelper>(context, listen: false).copy(note)),
  );
}

Widget archiveAction(
    final String label, final Color foregroundColor, final Note note) {
  return SlidableAction(
    autoClose: false,
    icon: Icons.archive_outlined,
    label: label,
    backgroundColor: Colors.transparent,
    foregroundColor: foregroundColor,
    onPressed: (final context) => unawaited(
        Provider.of<NotesHelper>(context, listen: false).archive(note)),
  );
}

Widget unHideAction(
    final String label, final Color foregroundColor, final Note note) {
  return SlidableAction(
    autoClose: false,
    icon: Icons.drive_file_move_outline,
    label: label,
    backgroundColor: Colors.transparent,
    foregroundColor: foregroundColor,
    onPressed: (final context) => unawaited(
        Provider.of<NotesHelper>(context, listen: false).unhide(note)),
  );
}

Widget unArchiveAction(
    final String label, final Color foregroundColor, final Note note) {
  return SlidableAction(
    autoClose: false,
    icon: Icons.unarchive_outlined,
    label: label,
    backgroundColor: Colors.transparent,
    foregroundColor: foregroundColor,
    onPressed: (final context) => unawaited(
        Provider.of<NotesHelper>(context, listen: false).unarchive(note)),
  );
}

Widget restoreAction(
    final String label, final Color foregroundColor, final Note note) {
  return SlidableAction(
    autoClose: false,
    icon: Icons.restore_from_trash_outlined,
    label: label,
    backgroundColor: Colors.transparent,
    foregroundColor: foregroundColor,
    onPressed: (final context) => unawaited(
        Provider.of<NotesHelper>(context, listen: false).undelete(note)),
  );
}
