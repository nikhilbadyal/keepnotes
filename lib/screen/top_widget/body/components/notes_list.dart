//25-11-2021 11:21 AM
import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

_NotesListState? homeBody;

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
  final Function(Note note, BuildContext context) primary;
  final Function(Note note, BuildContext context) secondary;

  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  bool isSelectionMode = false;
  Map<int, bool> selectedFlag = {};

  void callSetState() {
    setState(() {});
  }

  void loadMore() {
    Provider.of<NotesHelper>(context, listen: false)
        .getAllNotes(NoteState.unspecified.index)
        .then((final _) {
      setState(() {});
    });
  }

  @override
  Widget build(final BuildContext context) {
    homeBody = this;
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
            selectedFlag[index] = selectedFlag[index] ?? false;
            final isSelected = selectedFlag[index] ?? false;
            return Slidable(
              key: UniqueKey(),
              startActionPane: widget.primary(item, context),
              endActionPane: widget.secondary(item, context),
              child: NoteWidget(
                note: item,
                onItemTap: () => onItemTap(item, index, isSelected: isSelected),
                onItemLongPress: () =>
                    onItemLongPress(index, isSelected: isSelected),
                isSelected: isSelected,
                selectedFlag: selectedFlag,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> onItemTap(final Note item, final int index,
      {final bool isSelected = false,}) async {
    if (isSelectionMode) {
      setState(() {
        selectedFlag[index] = !isSelected;
        isSelectionMode = selectedFlag.containsValue(true);
      });
    } else {
      if (item.state == NoteState.trashed) {
        await showDialog<void>(
          barrierDismissible: true,
          context: context,
          builder: (final context) => MyAlertDialog(
            content: Text(Language.of(context).trashEditingWarning),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        await Navigator.pushNamed(context, AppRoutes.editScreen,
            arguments: item,);
      }
    }
  }

  void onItemLongPress(final int index, {final bool isSelected = false,}) {}
}
