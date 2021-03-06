import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_music/global.dart';
import 'package:flutter_music/player_state.dart';

const audioUrl =
    'https://wiboweb.com/wp-content/uploads/2019/03/Billie-Eilish-i-love-you-320.mp3';
const imgUrl =
    'https://amp.insider.com/images/5d10e5939c5101174c54bb98-1334-1001.jpg';

class SecondRoute extends StatefulWidget {
  @override
  _SecondRouteState createState() => new _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  Global _musicPlayer;

  StreamSubscription _positionSubscription;
  StreamSubscription _durationSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  @override
  void initState() {
    _musicPlayer = Global(url: audioUrl, title: 'I Love U', imgUrl: imgUrl);
    _initAudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _screenHeight = MediaQuery.of(context).size.height;
    final double _musicImgSize = _screenHeight / 2.1;

    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: _musicImgSize + 50,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _musicPlayer.musicImg(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
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
                          onTap: _musicPlayer.isPlaying
                              ? _musicPlayer.pauseMusic
                              : _musicPlayer.playMusic,
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
                        child: _musicPlayer.isStopped
                            ? Icon(
                                Icons.stop,
                                size: 25.0,
                                color: Colors.grey,
                              )
                            : IconButton(
                                onPressed: () =>
                                    _musicPlayer.stopMusic(force: true),
                                icon: Icon(
                                  Icons.stop,
                                  size: 25.0,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                      Flexible(
                        flex: 1,
                        child: _musicPlayer.isStopped
                            ? Icon(
                                Icons.loop,
                                size: 25.0,
                                color: Colors.grey,
                              )
                            : IconButton(
                                onPressed: () {
                                  _musicPlayer.loop = !_musicPlayer.loop;
                                },
                                icon: Icon(
                                  Icons.loop,
                                  size: 25.0,
                                  color: !_musicPlayer.loop
                                      ? Colors.grey
                                      : Colors.black,
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
                        child:
                            !_musicPlayer.isStopped || _musicPlayer.hasPosition
                                ? new Text(
                                    '${_musicPlayer.positionText ?? '0:00'}',
                                    style: new TextStyle(fontSize: 9.0),
                                  )
                                : new Text(
                                    '0:00',
                                    style: new TextStyle(fontSize: 9.0),
                                  ),
                      ),
                      Flexible(
                        flex: 10,
                        child: _musicPlayer.isStopped ||
                                !_musicPlayer.hasPosition ||
                                !_musicPlayer.hasDuration
                            ? Slider(
                                value: 0,
                                onChanged: (double value) => null,
                                activeColor: Colors.grey,
                                inactiveColor: Colors.grey,
                              )
                            : Slider(
                                min: 0,
                                max: _musicPlayer.duration.inMilliseconds
                                    .toDouble(),
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
                                style: new TextStyle(fontSize: 9.0),
                              )
                            : new Text(
                                '0:00',
                                style: new TextStyle(fontSize: 9.0),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _initAudioPlayer() {
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
