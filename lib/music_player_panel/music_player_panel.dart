import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_music/global.dart';
import 'package:flutter_music/music_player_panel/bottom_player_panel.dart';
import 'package:flutter_music/music_player_panel/now_playing/now_plaing_screen.dart';
import 'package:flutter_music/player_state.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MusicPlayerPanel extends StatefulWidget {
  @override
  MusicPlayerPanelState createState() => MusicPlayerPanelState();
}

class MusicPlayerPanelState extends State<MusicPlayerPanel> {
  PanelController _panelController;
  Global _musicPlayer;

  StreamSubscription _positionSubscription;
  StreamSubscription _durationSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

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
        ? Container()
        : Scaffold(
            body: SlidingUpPanel(
              panel: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_radius),
                  topRight: Radius.circular(_radius),
                ),
                child: NowPlayingScreen(panelController: _panelController),
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
                child: BottomPlayerPanel(panelController: _panelController),
              ),
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
