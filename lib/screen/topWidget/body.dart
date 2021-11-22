import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class Body extends StatefulWidget {
  const Body({
    required this.fromWhere,
    required this.primary,
    required this.secondary,
    final Key? key,
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
    super.initState();
    myFuture = Provider.of<NotesHelper>(context, listen: false)
        .getAllNotes(widget.fromWhere.index);
  }

  @override
  Widget build(final BuildContext context) {
    return FutureBuilder(
      future: myFuture,
      builder: (final context, final projectSnap) {
        if (projectSnap.connectionState == ConnectionState.done) {
          return Consumer<NotesHelper>(
            builder: (final context, final notehelper, final _) {
              if (notehelper.mainNotes.isEmpty) {
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
          final spinkit = SpinKitCircle(
            color: Theme.of(context).colorScheme.secondary,
            size: MediaQuery.of(context).size.height * 0.1,
          );
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Scaffold(
              body: Center(
                child: spinkit,
              ),
            ),
          );
        }
      },
    );
  }
}

_NonEmptyUiState? homeBody;

class NonEmptyUi extends StatefulWidget {
  const NonEmptyUi({
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
  _NonEmptyUiState createState() => _NonEmptyUiState();
}

class _NonEmptyUiState extends State<NonEmptyUi> {
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
        onNotification: (final ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels < 500) {
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
      ),
    );
  }

  Future<void> onItemTap(final Note item, final int index,
      {final bool isSelected = false}) async {
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
          builder: (final context) => MyAlertDialog(
            content: Text(Language.of(context).trashEditingWarning),
          ),
        );
      } else {
        await goToNoteEditScreen(context: context, note: item);
      }
    }
  }

  void onItemLongPress(final int index, {final bool isSelected = false}) {}
}
