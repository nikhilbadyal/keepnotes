import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class NoNotesUi extends StatelessWidget {
  const NoNotesUi({
    required this.noteState,
    Key? key,
  }) : super(key: key);
  final NoteState noteState;

  @override
  Widget build(BuildContext context) => Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const ImageWig(),
              if (noteState == NoteState.deleted)
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: Language.of(context).nothingHere,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: '\t\t\t\t\t\t\t'
                              '${Language.of(context).nothingHere}\n',
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color),
                        ),
                        TextSpan(
                          text: Language.of(context).tapOn,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color),
                        ),
                        TextSpan(
                          text: '+',
                          style: TextStyle(
                            fontSize: 30,
                            color: Theme.of(context)
                                .floatingActionButtonTheme
                                .backgroundColor,
                            fontWeight: FontWeight.normal,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              final emptyNote = Note(
                                id: const Uuid().v4(),
                                lastModify: DateTime.now(),
                                state: noteState,
                              );
                              goToNoteEditScreen(
                                  context: context, note: emptyNote);
                            },
                        ),
                        TextSpan(
                          text: Language.of(context).toAddNewNote,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
}

class ImageWig extends StatelessWidget {
  const ImageWig({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.5,
        child: Image.asset(
          'assets/images/noNotes.png',
          fit: BoxFit.contain,
          width: 120,
          height: 200,
        ),
      );
}
