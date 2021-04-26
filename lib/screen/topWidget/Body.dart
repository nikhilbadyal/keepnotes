import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes/model/Languages.dart';
import 'package:notes/model/Note.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/util/Navigations.dart';
import 'package:notes/widget/AlertDialog.dart';
import 'package:notes/widget/ItemsList.dart';
import 'package:notes/widget/NoNotes.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  const Body({
    required this.fromWhere,
    required this.primary,
    required this.secondary,
    Key? key,
  }) : super(key: key);

  final NoteState fromWhere;

  final Function(Note note, BuildContext context) primary;

  final Function(Note note, BuildContext context) secondary;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future myFuture;

  @override
  void initState() {
    myFuture = Provider.of<NotesHelper>(context, listen: false)
        .getAllNotesHelper(widget.fromWhere.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.fromWhere != NoteState.unspecified,
        'This is only for home body');
    return FutureBuilder(
      future: myFuture,
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.done) {
          return Consumer<NotesHelper>(
            builder: (context, notehelper, _) {
              if (notehelper.otherNotes.isEmpty) {
                return NoNotesUi(noteState: widget.fromWhere);
              } else {
                return NonEmptyUi(
                  notehelper: notehelper,
                  fromWhere: widget.fromWhere,
                  primary: widget.primary,
                  secondary: widget.secondary,
                );
              }
            },
          );
        } else {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class NonEmptyUi extends StatefulWidget {
  const NonEmptyUi({
    required this.notehelper,
    required this.fromWhere,
    required this.primary,
    required this.secondary,
    Key? key,
  }) : super(key: key);

  final NotesHelper notehelper;

  final NoteState fromWhere;
  final Function(Note note, BuildContext context) primary;
  final Function(Note note, BuildContext context) secondary;

  @override
  _NonEmptyUiState createState() => _NonEmptyUiState();
}

class _NonEmptyUiState extends State<NonEmptyUi> {
  bool isSelectionMode = false;
  Map<int, bool> selectedFlag = {};

  void callSetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(),
        child: ListView.builder(
          cacheExtent: 100000,
          physics: const BouncingScrollPhysics(),
          itemCount: widget.notehelper.otherNotes.length,
          itemBuilder: (context, index) {
            final item = widget.notehelper.otherNotes[index];
            selectedFlag[index] = selectedFlag[index] ?? false;
            final isSelected = selectedFlag[index] ?? false;
            return Slidable(
              key: UniqueKey(),
              actions: widget.primary(item, context),
              secondaryActions: widget.secondary(item, context),
              actionPane: const SlidableDrawerActionPane(),
              child: ListItem(
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
      );

  Future<void> onItemTap(Note item, int index,
      {bool isSelected = false}) async {
    if (isSelectionMode) {
      setState(() {
        selectedFlag[index] = !isSelected;
        isSelectionMode = selectedFlag.containsValue(true);
      });
    } else {
      if (item.state == NoteState.deleted) {
        await showDialog<void>(
          barrierDismissible: true,
          context: context,
          builder: (context) => MyAlertDialog(
            title: Text(Language.of(context).message),
            content: Text(Language.of(context).trashEditingWarning),
          ),
        );
      } else {
        await goToNoteEditScreen(context: context, note: item);
      }
    }
  }

  void onItemLongPress(int index, {bool isSelected = false}) {
    /*setState(() {
      selectedFlag[index] = !isSelected;
      isSelectionMode = selectedFlag.containsValue(true);
    });*/
  }
}
