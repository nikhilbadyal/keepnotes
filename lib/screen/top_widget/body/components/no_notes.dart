import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class NoNotesBody extends StatelessWidget {
  const NoNotesBody({
    required this.noteState,
    final Key? key,
  }) : super(key: key);
  final NoteState noteState;

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const ImageWig(),
            if (noteState == NoteState.trashed)
              Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: Language.of(context).nothingHere,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: '${Language.of(context).nothingHere}\n',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                    TextSpan(
                      text: Language.of(context).tapOn,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                    TextSpan(
                      text: '+',
                      style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final emptyNote = NoteX.emptyNote.copyWith(
                            id: const Uuid().v4(),
                            lastModify: DateTime.now(),
                            state: noteState,
                          );
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();

                          await Navigator.pushNamed(
                            context,
                            AppRoutes.editScreen,
                            arguments: emptyNote,
                          );
                        },
                    ),
                    TextSpan(
                      text: Language.of(context).toAddNewNote,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ImageWig extends StatelessWidget {
  const ImageWig({
    final Key? key,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.5,
      child: Image.asset(
        noNotes,
        fit: BoxFit.contain,
        width: 120,
        height: 200,
      ),
    );
  }
}
