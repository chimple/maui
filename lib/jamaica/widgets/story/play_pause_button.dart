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
      return Container(
        width: double.infinity,
        child: storyMode != StoryMode.textHighlighterMode
            ? InkWell(
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
                  maxRadius: constraint.maxHeight,
                  // backgroundColor: Colors.white,
                  child: isPause
                      ? Icon(
                          Icons.play_arrow,
                          size: constraint.maxHeight * .9,
                        )
                      : Icon(Icons.pause, size: constraint.maxHeight * .9),
                ),
              )
            : Container(),
      );
    });
  }
}
