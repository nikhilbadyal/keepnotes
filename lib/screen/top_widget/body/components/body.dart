import 'package:notes/_aap_packages.dart';
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
                return NoNotesBody(noteState: widget.fromWhere);
              } else {
                return NotesList(
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
            child: Center(child: spinkit),
          );
        }
      },
    );
  }
}
