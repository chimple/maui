import 'package:flutter/material.dart';
import 'package:maui/util/audio_service.dart';

class AudioWidget extends StatefulWidget {
  final String word;
  final bool play;

  const AudioWidget({Key key, this.word, this.play = false}) : super(key: key);

  @override
  _AudioWidgetState createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (widget.play) _play();
  }

  @override
  void didUpdateWidget(AudioWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!isPlaying && widget.play) isPlaying = true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child:
          isPlaying ? Icon(Icons.play_circle_filled) : Icon(Icons.play_arrow),
      onPressed: _play,
    );
  }

  void _play() {
    setState(() => isPlaying = true);
    AudioService.play(
        name: 'audio/${widget.word}.ogg',
        onEndCallback: () => setState(() => isPlaying = false));
  }
}
