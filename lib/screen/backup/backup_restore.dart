import 'package:notes/_app_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class BackUpScreenHelper extends StatefulWidget {
  const BackUpScreenHelper({Key? key}) : super(key: key);

  @override
  _BackUpScreenHelperState createState() => _BackUpScreenHelperState();
}

class _BackUpScreenHelperState extends State<BackUpScreenHelper>
    with TickerProviderStateMixin {
  double padding = 150;
  double bottomPadding = 0;

  @override
  Widget build(BuildContext context) => Align(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Text(
                  Language.of(context).backupWarning,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline5!.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              ElevatedButton(
                onPressed: () async {
                  // TODO fix this
                  /*final items =
                      await Provider.of<NotesHelper>(context, listen: false)
                          .getAll();
                  if (items.isNotEmpty) {
                    unawaited(
                      exportToFile(items).then(
                        (value) {
                          if (value) {
                            Utilities.showSnackbar(
                              context,
                              Language.of(context).done,
                            );
                          } else {
                            Utilities.showSnackbar(
                              context,
                              Language.of(context).error,
                            );
                          }
                        },
                      ),
                    );
                    Utilities.showSnackbar(
                      context,
                      Language.of(context).backupScheduled,
                    );
                  } else {
                    Utilities.showSnackbar(
                      context,
                      Language.of(context).done,
                    );
                  }*/
                },
                child: Text(
                  Language.of(context).exportNotes,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (await Utilities.requestPermission(Permission.storage)) {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['json'],
                    );
                    File file;
                    if (result != null) {
                      file = File(result.files.single.path!);
                      await importFromFile(file);
                    }
                  } else {
                    Utilities.showSnackbar(
                      context,
                      Language.of(context).permissionError,
                    );
                  }
                },
                child: Text(
                  Language.of(context).importNotes,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );

  Future<bool> exportToFile(List<dynamic> items) async {
    try {
      if (await Utilities.requestPermission(Permission.storage)) {
        final str = DateFormat('yyyyMMdd_HHmmss').format(
          DateTime.now(),
        );
        final fileName = 'Export_$str.json';
        const folderName = '/${Utilities.appName}/';
        final path =
            Provider.of<LockChecker>(context, listen: false).exportPath;
        final finalPath = path + folderName + fileName;
        try {
          await File(finalPath).create(recursive: true);
        } on Exception catch (_) {
          return false;
        }
        final file = File(finalPath);
        final jsonList = [];

        for (final Note note in items) {
          jsonList.add(json.encode(note.toMap()));
        }
        file.writeAsStringSync(
          jsonList.toString(),
        );
      } else {
        await showDialog<void>(
          barrierDismissible: true,
          context: context,
          builder: (context) => MyAlertDialog(
            title: Text(Language.of(context).error),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(Language.of(context).permissionError),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: Text(Language.of(context).alertDialogOp2),
              ),
            ],
          ),
        );
        return false;
      }
    } on Exception catch (_) {
      return false;
    }
    return true;
  }

  Future<void> importFromFile(File file) async {
    try {
      // final String stringContent = file.readAsStringSync();
      // final List jsonList = json.decode(stringContent);
      /*final notesList = jsonList
          .map(
            (json) => json,
          )
          .toList();*/
      // TODO work on this option
      // await Provider.of<NotesHelper>(context, listen: false).addAll(notesList);
      Utilities.showSnackbar(
        context,
        Language.of(context).done,
      );
    } on Exception catch (_) {
      Utilities.showSnackbar(
        context,
        Language.of(context).error,
      );
    }
  }
}
