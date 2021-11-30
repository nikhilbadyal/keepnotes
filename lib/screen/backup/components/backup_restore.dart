import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class BackUpScreen extends StatefulWidget {
  const BackUpScreen({final Key? key}) : super(key: key);

  @override
  _BackUpScreenState createState() => _BackUpScreenState();
}

class _BackUpScreenState extends State<BackUpScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(final BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const ImageWig(),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Text(
                  Language.of(context).soon,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).textTheme.bodyText1!.color),
                ),
              ),
            ),
            TextButton(
                onPressed: () => importFromFile(),
                child: const Text('Pick me')),
          ],
        ),
      ),
    );
  }
}


Future<bool> requestPermission(final Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    final result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
  }
  return false;
}

Future<bool> exportToFile() async {
  if (await requestPermission(Permission.storage)) {
    final str = DateFormat('yyyyMMdd_HHmmss').format(
      DateTime.now(),
    );
    final fileName = 'KEEP_$str.json';
    final generalDownloadDir = Directory('/storage/emulated/0/Download');
    try {
      final file = await File('${generalDownloadDir.path}/$fileName').create();
      final data = await FirebaseDatabaseHelper.getAll();
      final items = data.docs.map((final e) => e.data()).toList();

      await file.writeAsString(json.encode(items));
    } on Exception catch (_) {
      return false;
    }
    return true;
  } else {
    return false;
  }
}

Future<void> importFromFile() async {
  try {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = File(result.files.single.path ?? '');
      final stringContent = file.readAsStringSync();
      final List<dynamic> jsonList = json.decode(stringContent);
      for (final element in jsonList) {
        element['id'] = const Uuid().v4();
      }
      await SqfliteDatabaseHelper.batchInsert1(jsonList);
      await FirebaseDatabaseHelper.batchInsert1(jsonList);
    } else {
      // User canceled the picker
    }
  } catch (e) {
    logger.wtf('Failed to import $e');
  }
}
