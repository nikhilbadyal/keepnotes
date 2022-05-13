//01-12-2021 01:57 PM
import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

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
      final data = await FirebaseHelper.getAll();
      final items = data.docs
          .map(
            (final e) => e.data(),
          )
          .toList();

      await file.writeAsString(
        json.encode(items),
      );
    } on Exception catch (_) {
      return false;
    }
    return true;
  } else {
    return false;
  }
}

Future<bool> importFromFile() async {
  try {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = File(result.files.single.path ?? '');
      final stringContent = file.readAsStringSync();
      final jsonList = json.decode(stringContent) as List<dynamic>;
      for (final element in jsonList) {
        element['id'] = const Uuid().v4();
      }
      // await SqfliteDatabaseHelper.batchInsert1(jsonList);
      await FirebaseHelper.batchInsert(jsonList);
      return true;
    } else {
      return false;
    }
  } catch (e) {
    logger.wtf('Failed to import $e');
  }
  return false;
}
