import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({
    final Key? key,
  }) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  bool isReadOnly = false;
  late Note note;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late String _titleFromInitial;
  late String _contentFromInitial;
  late Timer autoSaverTimer;
  late bool needFocus = false;

  @override
  Widget build(final BuildContext context) {
    note = ModalRoute.of(context)!.settings.arguments! as Note;
    _titleController.text = note.title;
    _contentController.text = note.content;
    _titleFromInitial = note.title;
    _contentFromInitial = note.content;
    autoSaverTimer =
        Timer.periodic(const Duration(seconds: backGroundTimer), (final timer) {
      backgroundSaveNote();
    });
    return ChangeNotifierProvider<CharCount>(
      create: (final _) => CharCount(_contentFromInitial.length),
      child: WillPopScope(
        onWillPop: onBackPress,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: EditAppBar(
            note: note,
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
            note: note,
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
      await Provider.of<NotesHelper>(context, listen: false).insert(note);
    }
    return true;
  }

  Future<void> backgroundSaveNote() async {
    updateNote();
  }

  bool updateNote() {
    note
      ..title = _titleController.text.trim()
      ..content = _contentController.text.trim();
    if (!(note.title == _titleFromInitial &&
        note.content == _contentFromInitial)) {
      note.lastModify = DateTime.now();
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
