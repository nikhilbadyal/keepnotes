import 'dart:async';

import 'package:notes/_externalPackages.dart';
import 'package:notes/model/_model.dart';
import 'package:notes/util/_util.dart';
import 'package:notes/widget/_widgets.dart';
import 'package:notes/_internalPackages.dart';

class HomeNoteOptions extends StatefulWidget {
  const HomeNoteOptions({
    required this.note,
    required this.autoSaver,
    required this.saveNote,
    Key? key,
  }) : super(key: key);

  final Note note;
  final Timer autoSaver;
  final Function() saveNote;

  @override
  _HomeNoteOptionsState createState() => _HomeNoteOptionsState();
}

class _HomeNoteOptionsState extends State<HomeNoteOptions> {
  @override
  Widget build(BuildContext context) => Wrap(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_outlined),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 16),
                Text(Language.of(context).options),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              children: [
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    ModalSheetWidget(
                      label: Language.of(context).hide,
                      icon: TablerIcons.ghost,
                      onTap: () {
                        Utilities.onModalHideTap(context, widget.note,
                            widget.autoSaver, widget.saveNote);
                      },
                    ),
                    ModalSheetWidget(
                      onTap: () {
                        Utilities.onModalArchiveTap(context, widget.note,
                            widget.autoSaver, widget.saveNote);
                      },
                      icon: Icons.archive_outlined,
                      label: Language.of(context).archive,
                    ),
                    ModalSheetWidget(
                      icon: TablerIcons.copy,
                      onTap: () async {
                        await Utilities.onModalCopyToClipboardTap(context,
                            widget.note, widget.autoSaver, widget.saveNote);
                      },
                      label: Language.of(context).clipboard,
                    ),
                    ModalSheetWidget(
                      icon: Icons.delete_outlined,
                      onTap: () async {
                        await Utilities.onModalTrashTap(context, widget.note,
                            widget.autoSaver, widget.saveNote);
                      },
                      label: Language.of(context).trash,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      );

  Future<void> onHideTap() async {
    final status =
        Provider.of<LockChecker>(context, listen: false).password.isNotEmpty;
    if (!status) {
      await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => MyAlertDialog(
          title: Text(Language.of(context).message),
          content: Text(Language.of(context).setPasswordFirst),
        ),
      );
    } else {
      widget.autoSaver.cancel();
      widget.saveNote();
      final wantedRoute = getRoute(widget.note.state);
      await Utilities.onHideTap(context, widget.note);
      Navigator.of(context).popUntil(
        (route) => route.settings.name == wantedRoute,
      );
    }
  }
}
