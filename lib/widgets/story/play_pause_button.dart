import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:maui/widgets/story/audio_text_bold.dart';

class PlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final TextToSpeechType textToSpeachType;
  final bool isPause;
  final VoidCallback loadAudio;
  final AudioPlayer audioPlayer;
  final VoidCallback resume;
  final VoidCallback pause;
  final VoidCallback speak;
  PlayPauseButton(
      {this.isPlaying,
      this.textToSpeachType = TextToSpeechType.audio,
      this.isPause,
      this.loadAudio,
      this.audioPlayer,
      this.speak,
      this.pause,
      this.resume});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      if (textToSpeachType == TextToSpeechType.audio) {
        return InkWell(
          customBorder: CircleBorder(),
          onTap: !isPlaying
              ? () => loadAudio()
              : () {
                  if (audioPlayer.state == AudioPlayerState.PAUSED ||
                      audioPlayer.state == AudioPlayerState.COMPLETED ||
                      audioPlayer.state == AudioPlayerState.STOPPED)
                    resume();
                  else if (audioPlayer.state == AudioPlayerState.PLAYING)
                    pause();
                },
          child: isPause
              ? Icon(Icons.play_arrow,
                  size: constraint.maxHeight * .8, color: Colors.orange)
              : Icon(Icons.pause,
                  size: constraint.maxHeight * .8, color: Colors.orange),
        );
      } else {
        return InkWell(
          customBorder: CircleBorder(),
          onTap: () {
            if (isPause)
              speak();
            else
              pause();
          },
          child: isPause
              ? Icon(Icons.play_arrow,
                  size: constraint.maxHeight * .8, color: Colors.orange)
              : Icon(Icons.pause,
                  size: constraint.maxHeight * .8, color: Colors.orange),
        );
      }
    });
  }
}
