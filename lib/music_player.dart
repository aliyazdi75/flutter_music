import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_music/player_state.dart';
import 'package:media_notification/media_notification.dart';

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

  get durationText => durationConvert(duration);

  get positionText => durationConvert(position);

  get hasPosition => position != null;

  get hasDuration => duration != null;

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
    if (result == 1) {
      showNotification(title, title, true);
      playerState = PlayerState.playing;
    }
    return result;
  }

  Future<int> pauseMusic() async {
    final result = await audioPlayer.pause();
    if (result == 1) {
      showNotification(title, title, false);
      playerState = PlayerState.paused;
    }
    return result;
  }

  Future<int> stopMusic() async {
    final result = await audioPlayer.stop();
    if (result == 1) {
      playerState = PlayerState.stopped;
      hideNotification();
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
    stopMusic();
  }

  void invertSeekingState() {
    isAudioSeeking = !isAudioSeeking;
  }

  String durationConvert(Duration duration) {
    if (duration == null) return null;
    String time = '';
    int hours = duration.inHours;
    int minutes = duration.inMinutes - hours * 60;
    int seconds = duration.inSeconds - minutes * 60 - hours * 3600;
    if (hours > 0) {
      if (hours < 10)
        time += '0' + hours.toString() + ':';
      else
        time += hours.toString() + ':';
    }
    if (minutes < 10)
      time += '0' + minutes.toString() + ':';
    else
      time += minutes.toString();
    if (seconds < 10)
      time += '0' + seconds.toString();
    else
      time += seconds.toString();
    return time;
  }

  Future<void> hideNotification() async {
    try {
      await MediaNotification.hide();
    } on PlatformException {}
  }

  Future<void> showNotification(title, author, isPlaying) async {
    try {
      await MediaNotification.show(
          title: title, author: author, play: isPlaying);
    } on PlatformException {}
  }
}
