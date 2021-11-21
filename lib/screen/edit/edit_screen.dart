import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({final Key? key}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  bool isReadOnly = false;
  late Note noteInEditing;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late String _titleFromInitial;
  late String _contentFromInitial;
  late String oldName;
  late Timer autoSaverTimer;
  late Note currentNote;

  @override
  Widget build(final BuildContext context) {
    currentNote = ModalRoute.of(context)!.settings.arguments! as Note;
    noteInEditing = currentNote;
    _titleController.text = noteInEditing.title;
    _contentController.text = noteInEditing.content;
    _titleFromInitial = currentNote.title;
    _contentFromInitial = currentNote.content;
    autoSaverTimer = Timer.periodic(const Duration(seconds: 5), (final timer) {
      backgroundSaveNote();
    });
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        appBar: EditAppBar(
          note: noteInEditing,
          saveNote: saveNote,
          autoSaverTimer: autoSaverTimer,
        ),
        body: body(context),
        bottomSheet: BottomBar(
          note: noteInEditing,
          saveNote: saveNote,
          onIconTap: onPressed,
          isReadOnly: isReadOnly,
          autoSaverTimer: autoSaverTimer,
        ),
      ),
    );
  }

  Widget body(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          bottom: kBottomNavigationBarHeight, left: 10, right: 10),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            TextField(
              readOnly: isReadOnly,
              controller: _titleController,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                  hintText: Language.of(context).enterNoteTitle,
                  border: InputBorder.none),
            ),
            TextField(
              autofocus:
                  _contentFromInitial.isEmpty && _titleFromInitial.isEmpty,
              readOnly: isReadOnly,
              controller: _contentController,
              maxLines: null,
              showCursor: true,
              style: const TextStyle(
                fontSize: 15,
              ),
              decoration: InputDecoration(
                  hintText: Language.of(context).enterNoteContent,
                  border: InputBorder.none),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
  }

  Future<bool> onBackPress() async {
    autoSaverTimer.cancel();
    await saveNote();
    return true;
  }

  Future<bool> saveNote() async {
    final isEdited = updateNote();
    if (isEdited) {
      await Provider.of<NotesHelper>(context, listen: false)
          .insert(noteInEditing);
    }
    return true;
  }

  Future<void> backgroundSaveNote() async {
    updateNote();
  }

  bool updateNote() {
    noteInEditing.title = _titleController.text.trim();
    // ignore: cascade_invocations
    noteInEditing.content = _contentController.text.trim();
    if (!(noteInEditing.title == _titleFromInitial &&
        noteInEditing.content == _contentFromInitial)) {
      noteInEditing.lastModify = DateTime.now();
      return true;
    }
    return false;
  }

  Future<void> exitWithoutSaving(final BuildContext context) async {
    autoSaverTimer.cancel();
    Navigator.pop(context);
  }

  void onPressed() {
    setState(() {
      isReadOnly = !isReadOnly;
    });
  }
}
