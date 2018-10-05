import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

typedef void OnError(Exception exception);

class GameAudio {
  AudioPlayer audioPlayer = new AudioPlayer();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future _loadAsset(String type) async {
    return await rootBundle.load('assets/$type.wav');
  }

  Future right() async {
    try {
      final path = await _localPath;
      final file = new File('$path/_audioright.mp3');
      if (await file.exists()) {
        print('file exist');
        await audioPlayer.play(file.path, isLocal: true);
      } else {
        await file
            .writeAsBytes((await _loadAsset('right')).buffer.asUint8List());
        await audioPlayer.play(file.path, isLocal: true);
      }
    } catch (e) {}
  }

  Future wrong() async {
    try {
      final path = await _localPath;
      final file = new File('$path/_audiowrong.mp3');
      if (await file.exists()) {
        print('file exist');
        await audioPlayer.play(file.path, isLocal: true);
      } else {
        await file
            .writeAsBytes((await _loadAsset('wrong')).buffer.asUint8List());
        await audioPlayer.play(file.path, isLocal: true);
      }
    } catch (e) {
      print('nikk  exception $e');
    }
  }

  Future tap() async {
    try {
      final path = await _localPath;
      final file = new File('$path/_audiotap.mp3');
      if (await file.exists()) {
        print('file exist');
        await audioPlayer.play(file.path, isLocal: true);
      } else {
        await file.writeAsBytes((await _loadAsset('tap')).buffer.asUint8List());
        await audioPlayer.play(file.path, isLocal: true);
      }
    } catch (e) {}
  }
}
