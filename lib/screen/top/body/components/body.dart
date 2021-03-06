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

  final ActionPane? Function(Note note, BuildContext context) primary;

  final ActionPane? Function(Note note, BuildContext context) secondary;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<void> myFuture;

  @override
  void initState() {
    super.initState();
    myFuture = context.noteHelper.getAllNotes(widget.fromWhere.index);
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
            color: context.secondaryColor,
            size: context.mq.size.height * 0.1,
          );
          return SizedBox(
            height: context.mq.size.height,
            width: context.mq.size.width,
            child: Center(child: spinkit),
          );
        }
      },
    );
  }
}
