import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/app.dart';
import 'package:notes/model/Note.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/screen/TapToExpand.dart';
import 'package:notes/util/AppRoutes.dart';
import 'package:notes/util/Navigations.dart';
import 'package:notes/util/Utilites.dart';
import 'package:pedantic/pedantic.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class BackUpScreenHelper extends StatefulWidget {
  const BackUpScreenHelper();

  @override
  _BackUpScreenHelperState createState() => _BackUpScreenHelperState();
}

class _BackUpScreenHelperState extends State<BackUpScreenHelper>
    with TickerProviderStateMixin {
  var padding = 150.0;
  var bottomPadding = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedPadding(
                padding: EdgeInsets.only(top: padding, bottom: bottomPadding),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.fastLinearToSlowEaseIn,
                child: SizedBox(
                  child: CardItem(
                    Theme.of(context).accentColor,
                    '',
                    '',
                    '',
                    () {
                      setState(() {
                        padding = padding == 0 ? 150.0 : 0.0;
                        bottomPadding = bottomPadding == 0 ? 150 : 0.0;
                      });
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(right: 20, left: 20, top: 200),
                  height: 180,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2), blurRadius: 30)
                    ],
                    color: Colors.grey.shade200.withOpacity(1.0),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Icon(Icons.favorite,
                        color: Theme.of(context).accentColor.withOpacity(1.0),
                        size: 70),
                  ),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  final items =
                      await Provider.of<NotesHelper>(context, listen: false)
                          .getNotesAllForBackupHelper();
                  if (items.isNotEmpty) {
                    unawaited(
                      exportToFile(items).then(
                        (_) {
                          Utilities.showSnackbar(
                            context,
                            'Notes Exported',
                          );
                        },
                      ),
                    );
                    Utilities.showSnackbar(
                      context,
                      'Backup Scheduled',
                    );
                  } else {
                    Utilities.showSnackbar(
                      context,
                      'Nothing to export',
                    );
                  }
                },
                child: const Text(
                  'Export Notes ',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 20,
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
                      'Permission Not granted',
                    );
                  }
                },
                child: const Text(
                  'Import Notes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> exportToFile(List<dynamic> items) async {
    try {
      if (await Utilities.requestPermission(Permission.storage)) {
        final str = DateFormat('yyyyMMdd_HHmmss').format(
          DateTime.now(),
        );
        final fileName = 'Export_$str.json';
        const folderName = '/NotesApp/';
        final path = myNotes.lockChecker.exportPath;
        final finalPath = path + folderName + fileName;
        try {
          await File(finalPath).create(recursive: true);
        } catch (e) {
          throw Error();
        }
        final file = File(finalPath);
        final jsonList = [];

        for (final note in items) {
          jsonList.add(json.encode(note.toJson()));
        }

        file.writeAsStringSync(
          jsonList.toString(),
        );
      }
    } catch (e) {
      Utilities.showSnackbar(
        context,
        'Error while exporting',
      );
    }
  }

  Future<void> importFromFile(File file) async {
    try {
      final stringContent = file.readAsStringSync();
      final List jsonList = json.decode(stringContent);
      final notesList = jsonList
          .map(
            (json) => Note.fromJson(json),
          )
          .toList();
      await Provider.of<NotesHelper>(context, listen: false)
          .addAllNotesToDatabaseHelper(notesList);
      Utilities.showSnackbar(
        context,
        'Done importing',
      );
      await navigate(ModalRoute.of(context)!.settings.name!, context,
          NotesRoutes.homeScreen);
    } catch (e) {
      // debugPrint(e.toString());
      Utilities.showSnackbar(
        context,
        'Error while importing',
      );
    }
  }
}
