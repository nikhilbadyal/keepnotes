import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes/model/Languages.dart';
import 'package:notes/model/Note.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/util/LockManager.dart';
import 'package:notes/util/Navigations.dart';
import 'package:notes/widget/AlertDialog.dart';
import 'package:notes/widget/ItemsList.dart';
import 'package:notes/widget/NoNotes.dart';
import 'package:provider/provider.dart';

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
        .getAllNotesHelper(NoteState.unspecified.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => showOldVersionUsed());
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
                  notehelper: notehelper,
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

  Future<void>? showOldVersionUsed() async {
    if (Provider.of<LockChecker>(context, listen: false).usedOlderVersion) {
      final used = await showDialog<bool>(
            context: context,
            builder: (_) => MyAlertDialog(
              title: Text(Language.of(context).message),
              content: Text(
                Language.of(context).oldVersionWarning,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Never used old version'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(Language.of(context).alreadyDone),
                ),
                TextButton(
                  onPressed: () {
                    Provider.of<NotesHelper>(context, listen: false)
                        .autoMateEverything();

                    Navigator.of(context).pop(false);
                  },
                  child: Text(Language.of(context).doItForMe),
                ),
              ],
            ),
          ) ??
          true;
      if (!used) {
        Provider.of<LockChecker>(context, listen: false).usedOlderVersion =
            false;
        await Provider.of<LockChecker>(context, listen: false)
            .setUsedOlderVersion();
      }
    }
  }
}

_NonEmptyHomeUiState? homeBody;

class NonEmptyHomeUi extends StatefulWidget {
  const NonEmptyHomeUi({
    required this.notehelper,
    required this.primary,
    required this.secondary,
    Key? key,
  }) : super(key: key);

  final NotesHelper notehelper;

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
      padding: const EdgeInsets.only(),
      child: ListView.builder(
        cacheExtent: 100000,
        physics: const BouncingScrollPhysics(),
        itemCount: widget.notehelper.mainNotes.length,
        itemBuilder: (context, index) {
          final item = widget.notehelper.mainNotes[index];
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

  void onItemLongPress(int index, {bool isSelected = false}) {
    /*setState(() {
      selectedFlag[index] = !isSelected;
      isSelectionMode = selectedFlag.containsValue(true);
    });*/
  }
}
