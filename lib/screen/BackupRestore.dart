import 'dart:convert';
import 'dart:io';

// import 'package:ext_storage/ext_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:notes/app.dart';
import 'package:notes/model/database/NotesHelper.dart';
import 'package:notes/model/note.dart';
import 'package:notes/util/Utilites.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class BackUpScreenHelper extends StatefulWidget {
  const BackUpScreenHelper();

  @override
  _BackUpScreenHelperState createState() => _BackUpScreenHelperState();
}

class _BackUpScreenHelperState extends State<BackUpScreenHelper>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    //debugPrint('building 7');
    return Container(
      padding: const EdgeInsets.all(30),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  final items =
                      await Provider.of<NotesHelper>(context, listen: false)
                          .getNotesAllForBackupHelper();
                  await exportToFile(items);
                  Utilities.showSnackbar(
                    context,
                    'Notes Exported',
                  );
                },
                child: const Text(
                  'Export Notes',
                  style: TextStyle(color: Colors.white),
                ),
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
        ),
      ),
    );
  }

  Future<void> exportToFile(List<dynamic> items) async {
    try {
      if (await Utilities.requestPermission(Permission.storage)) {
        final filePath =
            await File(myNotes.lockChecker.exportPath).create(recursive: true);
        final jsonList = [];
        for (final note in items) {
          jsonList.add(json.encode(note.toJson()));
        }
        filePath.writeAsStringSync(
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
      /*final stringContent = file.readAsStringSync();
      final Map<String, dynamic> jsonList = json.decode(stringContent);
      final notesList = jsonList
          .map(
            (json) => Note.fromJson(json),
          )
          .toList();
      */ /*debugPrint('Hello this is me');
      for (final ino in jsonList.keys) {
        debugPrint(ino);
      }*/ /*
      await Provider.of<NotesHelper>(context, listen: false)
          .addAllNotesToDatabseHelper(jsonList);*/
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
    } catch (e) {
      // debugPrint(e.toString());
      Utilities.showSnackbar(
        context,
        'Error while importing',
      );
    }
  }
}
