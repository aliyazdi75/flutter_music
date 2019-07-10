import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_music/player_state.dart';

class MusicPlayer {
  String url;
  String title;
  bool isLocal;
  PlayerMode mode;

  AudioPlayer audioPlayer;
  AudioPlayerState audioPlayerState;
  Duration duration;
  Duration position;
  bool hasError = false;
  bool loop = false;
  bool isAudioSeeking = false;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;

  get isStopped => playerState == PlayerState.stopped;

  get isPaused => playerState == PlayerState.paused;

  get durationText => duration?.toString()?.split('.')?.first ?? '';

  get positionText => position?.toString()?.split('.')?.first ?? '';

  get hasPosition => position != null;

  MusicPlayer(
      {this.url,
      this.title,
      this.isLocal = false,
      this.mode = PlayerMode.MEDIA_PLAYER}) {
    audioPlayer = AudioPlayer(mode: mode);
  }

  Future<int> playMusic() async {
    final playPosition = (position != null &&
            duration != null &&
            position.inMilliseconds > 0 &&
            position.inMilliseconds < duration.inMilliseconds)
        ? position
        : null;
    final result =
        await audioPlayer.play(url, isLocal: isLocal, position: playPosition);
    if (result == 1) playerState = PlayerState.playing;
    return result;
  }

  Future<int> pauseMusic() async {
    final result = await audioPlayer.pause();
    if (result == 1) playerState = PlayerState.paused;
    return result;
  }

  Future<int> stopMusic() async {
    final result = await audioPlayer.stop();
    if (result == 1) {
      playerState = PlayerState.stopped;
      position = Duration();
    }
    return result;
  }

  void playSameMusic() {}

  void onMusicComplete() {
    if (loop) {
      playSameMusic();
      return;
    }
    playerState = PlayerState.stopped;
  }

  void invertSeekingState() {
    isAudioSeeking = !isAudioSeeking;
  }
}
