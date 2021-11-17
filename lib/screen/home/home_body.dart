import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';
import 'package:notes/util/_util.dart';
import 'package:notes/widget/_widgets.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({
    required this.primary,
    required this.secondary,
    Key? key,
  }) : super(key: key);

  final Function(Note note, BuildContext context) primary;

  final Function(Note note, BuildContext context) secondary;

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late Future myFuture;

  @override
  void initState() {
    myFuture = Provider.of<NotesHelper>(context, listen: false)
        .getAllNotes(NoteState.unspecified.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: myFuture,
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.done) {
          return Consumer<NotesHelper>(
            builder: (context, notehelper, _) {
              if (notehelper.mainNotes.isEmpty) {
                return const NoNotesUi(noteState: NoteState.unspecified);
              } else {
                return NonEmptyHomeUi(
                  noteHelper: notehelper,
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
            child: const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}

_NonEmptyHomeUiState? homeBody;

class NonEmptyHomeUi extends StatefulWidget {
  const NonEmptyHomeUi({
    required this.noteHelper,
    required this.primary,
    required this.secondary,
    Key? key,
  }) : super(key: key);

  final NotesHelper noteHelper;

  final Function(Note note, BuildContext context) primary;
  final Function(Note note, BuildContext context) secondary;

  @override
  _NonEmptyHomeUiState createState() => _NonEmptyHomeUiState();
}

class _NonEmptyHomeUiState extends State<NonEmptyHomeUi> {
  bool isSelectionMode = false;
  Map<int, bool> selectedFlag = {};

  void callSetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    homeBody = this;
    return Padding(
      padding: EdgeInsets.zero,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: widget.noteHelper.mainNotes.length,
        itemBuilder: (context, index) {
          final item = widget.noteHelper.mainNotes.elementAt(index);
          selectedFlag[index] = selectedFlag[index] ?? false;
          final isSelected = selectedFlag[index] ?? false;
          return Slidable(
            key: UniqueKey(),
            startActionPane: widget.primary(item, context),
            endActionPane: widget.secondary(item, context),
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
  }

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

  void onItemLongPress(int index, {bool isSelected = false}) {}
}
