import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_music/global.dart';
import 'package:flutter_music/music_player_panel/now_playing/now_plaing_screen.dart';
import 'package:flutter_music/player_state.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottomPlayerPanel extends StatefulWidget {
  final Widget _fatherWidget;

  BottomPlayerPanel({@required Widget fatherWidget})
      : _fatherWidget = fatherWidget;

  @override
  State<StatefulWidget> createState() {
    return new _BottomPlayerPanelState(_fatherWidget);
  }
}

class _BottomPlayerPanelState extends State<BottomPlayerPanel> {
  PanelController _panelController;
  Widget _fatherWidget;
  Global _musicPlayer;

  StreamSubscription _positionSubscription;
  StreamSubscription _durationSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  _BottomPlayerPanelState(this._fatherWidget);

  @override
  void initState() {
    super.initState();
    _panelController = PanelController();
    _musicPlayer = Global();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _durationSubscription.cancel();
    _positionSubscription.cancel();
    _playerCompleteSubscription.cancel();
    _playerErrorSubscription.cancel();
    _playerStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _radius = 25.0;

    return _musicPlayer.hasError || _musicPlayer.closedPanel
        ? _fatherWidget
        : Scaffold(
            body: SlidingUpPanel(
              panel: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_radius),
                  topRight: Radius.circular(_radius),
                ),
                child: NowPlayingScreen(controller: _panelController),
              ),
              controller: _panelController,
              minHeight: 110,
              maxHeight: MediaQuery.of(context).size.height,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(_radius),
                topRight: Radius.circular(_radius),
              ),
              collapsed: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(_radius),
                    topRight: Radius.circular(_radius),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                      0.0,
                      0.7,
                    ],
                    colors: [
                      Color(0xFF47ACE1),
                      Color(0xFFDF5F9D),
                    ],
                  ),
                ),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.bottomCenter,
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
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: _musicPlayer.musicImg(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      Divider(
                                        height: 10,
                                        color: Colors.transparent,
                                      ),
                                      Text(
                                        _musicPlayer.title.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          letterSpacing: 1,
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
                                  onTap: () => _panelController.open(),
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        25,
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
                            Flexible(
                              flex: 1,
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    _musicPlayer.stopMusic(force: true);
                                    _musicPlayer.closedPanel = true;
                                  },
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        25,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.black,
                                        size: 18.0,
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
                              child: !_musicPlayer.isStopped ||
                                      _musicPlayer.hasPosition
                                  ? new Text(
                                      '${_musicPlayer.positionText ?? '0:00'}',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : new Text(
                                      '0:00',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
                                      value: _musicPlayer
                                                  .duration.inMilliseconds >
                                              _musicPlayer
                                                  .position.inMilliseconds
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
                                        _musicPlayer.audioPlayer
                                            .seek(_duration);
                                      },
                                      activeColor: Colors.black,
                                      inactiveColor:
                                          Colors.black.withOpacity(0.5),
                                    ),
                            ),
                            Flexible(
                              flex: 1,
                              child: _musicPlayer.hasDuration
                                  ? new Text(
                                      '${_musicPlayer.durationText ?? '0:00'}',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : new Text(
                                      '0:00',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: _fatherWidget,
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
