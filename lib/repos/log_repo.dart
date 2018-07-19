import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> writeLog(String text) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var fileName = prefs.getString('logFile');
    if (fileName == null || !File(fileName).existsSync()) {
      final extDir = await getExternalStorageDirectory();
      fileName = '${extDir.path}/Download/${Uuid().v4()}.maui.csv';
      prefs.setString('logFile', fileName);
    }
    final logFile = File(fileName);
    await logFile.writeAsString(
        '${DateTime.now().millisecondsSinceEpoch},$text\n',
        mode: FileMode.append,
        flush: true);
  } catch (e) {
    print(e);
  }
//  print('writeLog: wrote $text to $fileName');

  return true;
}
