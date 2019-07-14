import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_music/player_state.dart';
import 'package:media_notification/media_notification.dart';

class MusicPlayer {
  String url;
  String title;
  String imgUrl;
  bool isLocal;
  PlayerMode mode;

  AudioPlayer audioPlayer;
  AudioPlayerState audioPlayerState;
  Duration duration;
  Duration position;
  bool hasError = false;
  bool loop = false;
  bool closedPanel = true;
  bool isAudioSeeking = false;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;

  get isStopped => playerState == PlayerState.stopped;

  get isPaused => playerState == PlayerState.paused;

  get durationText => durationConvert(duration);

  get positionText => durationConvert(position);

  get hasPosition => position != null;

  get hasDuration => duration != null;

  get hasImg => musicImg() != null;

  MusicPlayer(
      {this.url,
      this.title,
      this.imgUrl,
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
      closedPanel = false;
      playerState = PlayerState.playing;
      showNotification(title, title, true);
    }
    return result;
  }

  Future<int> pauseMusic() async {
    final result = await audioPlayer.pause();
    if (result == 1) {
      playerState = PlayerState.paused;
      showNotification(title, title, false);
    }
    return result;
  }

  Future<void> stopMusic({bool force = false}) async {
    final result = await audioPlayer.stop();
    if (result == 1) {
      position = Duration();
      if (loop) {
        if (force) {
          loop = !loop;
          playerState = PlayerState.stopped;
          hideNotification();
        }
      } else {
        playerState = PlayerState.stopped;
        hideNotification();
      }
    }
    return result;
  }

  void onMusicComplete() {
    playerState = PlayerState.stopped;
    stopMusic();
    if (loop) {
      playMusic();
    }
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

  ImageProvider musicImg() {
    return NetworkImage(imgUrl);
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
