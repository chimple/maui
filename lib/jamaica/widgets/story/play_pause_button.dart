import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/widgets/story/show_dialog_mode.dart';

class PlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final isPause;
  final StoryMode storyMode;
  final VoidCallback loadAudio;
  final AudioPlayer audioPlayer;
  final VoidCallback resume;
  final VoidCallback pause;
  PlayPauseButton(
      {this.isPlaying,
      this.isPause,
      this.storyMode,
      this.loadAudio,
      this.audioPlayer,
      this.pause,
      this.resume});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return storyMode != StoryMode.textHighlighterMode
          ? InkWell(
              radius: constraint.maxHeight / 2,
              borderRadius: BorderRadius.circular(constraint.maxHeight / 2),
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
              child: CircleAvatar(
                radius: constraint.maxHeight * .8 / 2,
                // maxRadius: constraint.maxHeight * .8,
                backgroundColor: Colors.white,
                child: isPause
                    ? Icon(Icons.play_arrow,
                        size: constraint.maxHeight * .8, color: Colors.orange)
                    : Icon(Icons.pause,
                        size: constraint.maxHeight * .8, color: Colors.orange),
              ),
            )
          : Container();
    });
  }
}
