//25-11-2021 11:21 AM

import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class NotesList extends StatefulWidget {
  const NotesList({
    required this.notehelper,
    required this.fromWhere,
    required this.primary,
    required this.secondary,
    final Key? key,
  }) : super(key: key);

  final NotesHelper notehelper;

  final NoteState fromWhere;
  final ActionPane? Function(Note note, BuildContext context) primary;
  final ActionPane? Function(Note note, BuildContext context) secondary;

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  void callSetState() {
    setState(() {});
  }

  void loadMore() {
    context.noteHelper.getAllNotes(NoteState.unspecified.index).then((final _) {
      setState(() {});
    });
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: NotificationListener<ScrollNotification>(
        onNotification: (final scrollInfo) {
          if (scrollInfo.metrics.pixels < lazyLoadPixelFactor) {
            loadMore();
          }
          return false;
        },
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: widget.notehelper.mainNotes.length,
          itemBuilder: (final context, final index) {
            final item = widget.notehelper.mainNotes.elementAt(index);
            return Slidable(
              key: UniqueKey(),
              startActionPane: widget.primary(item, context),
              endActionPane: widget.secondary(item, context),
              child: NoteWidget(
                note: item,
                onItemTap: () => onItemTap(
                  item,
                  index,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> onItemTap(
    final Note item,
    final int index, {
    final bool isSelected = false,
  }) async {
    if (item.state == NoteState.trashed) {
      await showDialog<void>(
        barrierDismissible: true,
        context: context,
        builder: (final context) => MyAlertDialog(
          content: Text(context.language.trashEditingWarning),
        ),
      );
    } else {
      context.sm.removeCurrentSnackBar();
      context.nextPage(
        AppRoutes.editScreen,
        arguments: item,
      );
    }
  }
}
