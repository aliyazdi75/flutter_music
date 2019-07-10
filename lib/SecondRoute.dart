import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_music/player_state.dart';
import 'package:media_notification/media_notification.dart';

import 'global.dart';

const kUrl1 = 'https://luan.xyz/files/audio/ambient_c_motion.mp3';

class SecondRoute extends StatefulWidget {
  @override
  _SecondRouteState createState() => new _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  Global _musicPlayer = Global(url: kUrl1, title: 'ambient_c_motion');

  StreamSubscription _positionSubscription;
  StreamSubscription _durationSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  void dispose() {
//    _musicPlayer.audioPlayer.stop();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Container(
        height: 100.0,
        width: double.infinity,
        color: Colors.cyan,
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        if (_playerErrorSubscription != null) {
                          return;
                        }
                        if (_musicPlayer.isPlaying) {
                          _musicPlayer.pauseMusic();
                        } else {
                          _musicPlayer.playMusic();
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: _musicPlayer.isPlaying
                            ? IconButton(
                                onPressed: _musicPlayer.pauseMusic,
                                iconSize: 32.0,
                                icon: new Icon(Icons.pause),
                                color: Colors.black)
                            : IconButton(
                                onPressed: _musicPlayer.playMusic,
                                iconSize: 32.0,
                                icon: new Icon(Icons.play_arrow),
                                color: Colors.black),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _musicPlayer.title,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
//                            onTap: () => controller.open(),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(
                              32,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.keyboard_arrow_up,
                              color: Colors.black,
                              size: 22.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: !_musicPlayer.isStopped || _musicPlayer.hasPosition
                        ? new Text(
                            '${_musicPlayer.positionText ?? '0:00'}',
                            style: new TextStyle(fontSize: 10.0),
                          )
                        : new Text(
                            '0:00',
                            style: new TextStyle(fontSize: 10.0),
                          ),
                  ),
                  Flexible(
                    flex: 10,
                    child: _musicPlayer.isStopped || !_musicPlayer.hasPosition
                        ? Slider(
                            value: 0,
                            onChanged: (double value) => null,
                            activeColor: Colors.grey,
                            inactiveColor: Colors.grey,
                          )
                        : Slider(
                            min: 0,
                            max:
                                _musicPlayer.duration.inMilliseconds.toDouble(),
                            value: _musicPlayer.duration.inMilliseconds >
                                    _musicPlayer.position.inMilliseconds
                                ? _musicPlayer.position.inMilliseconds
                                    .toDouble()
                                : _musicPlayer.duration.inMilliseconds
                                    .toDouble(),
                            onChangeStart: (double value) =>
                                _musicPlayer.invertSeekingState(),
                            onChanged: (double value) {
                              final Duration _duration = Duration(
                                milliseconds: value.toInt(),
                              );
                              setState(() {
                                _musicPlayer.position = _duration;
                              });
                            },
                            onChangeEnd: (double value) {
                              final Duration _duration = Duration(
                                milliseconds: value.toInt(),
                              );
                              _musicPlayer.invertSeekingState();
                              _musicPlayer.audioPlayer.seek(_duration);
                            },
                            activeColor: Colors.black,
                            inactiveColor: Colors.black.withOpacity(0.5),
                          ),
                  ),
                  Flexible(
                    flex: 1,
                    child: _musicPlayer.hasDuration
                        ? new Text(
                            '${_musicPlayer.durationText ?? '0:00'}',
                            style: new TextStyle(fontSize: 10.0),
                          )
                        : new Text(
                            '0:00',
                            style: new TextStyle(fontSize: 10.0),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _initAudioPlayer() {
    MediaNotification.setListener('pause', () {
      setState(() => _musicPlayer.pauseMusic());
    });

    MediaNotification.setListener('play', () {
      setState(() => _musicPlayer.playMusic());
    });

    _durationSubscription = _musicPlayer.audioPlayer.onDurationChanged
        .listen((duration) => setState(() {
              _musicPlayer.duration = duration;
            }));

    _positionSubscription = _musicPlayer.audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() {
              _musicPlayer.position = p;
            }));

    _playerCompleteSubscription =
        _musicPlayer.audioPlayer.onPlayerCompletion.listen((event) {
      _musicPlayer.onMusicComplete();
      setState(() {
        _musicPlayer.position = _musicPlayer.duration;
      });
    });

    _playerErrorSubscription =
        _musicPlayer.audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _musicPlayer.playerState = PlayerState.stopped;
        _musicPlayer.duration = Duration(seconds: 0);
        _musicPlayer.position = Duration(seconds: 0);
        _musicPlayer.hasError = true;
      });
    });

    _musicPlayer.audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _musicPlayer.audioPlayerState = state;
      });
    });
  }
}
