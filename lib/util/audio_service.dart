import 'package:audioplayers/audio_cache.dart';

class AudioService {
  static AudioCache _cache = new AudioCache();

  static void play({String name, Function onEndCallback}) async {
    try {
      final player = await _cache.play(name);
      if (onEndCallback != null) player.completionHandler = onEndCallback;
    } catch (e) {
      print(e);
      onEndCallback();
    }
  }
}
