import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({final Key? key,}) : super(key: key);

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
    autoSaverTimer =
        Timer.periodic(const Duration(seconds: backGroundTimer), (final timer) {
      backgroundSaveNote();
    });
    return ChangeNotifierProvider<CharCount>(
      create: (final _) => CharCount(_contentFromInitial.length),
      child: WillPopScope(
        onWillPop: onBackPress,
        child: Scaffold(
          appBar: EditAppBar(
            note: noteInEditing,
            saveNote: saveNote,
            autoSaverTimer: autoSaverTimer,
          ),
          body: EditBody(
            isReadOnly: isReadOnly,
            contentController: _contentController,
            titleController: _titleController,
            autofocus: _contentFromInitial.isEmpty && _titleFromInitial.isEmpty,
          ),
          bottomSheet: BottomBar(
            note: noteInEditing,
            saveNote: saveNote,
            onIconTap: onPressed,
            isReadOnly: isReadOnly,
            autoSaverTimer: autoSaverTimer,
          ),
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
