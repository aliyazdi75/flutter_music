import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music/global.dart';
import 'package:flutter_music/music_player_panel//now_playing/music_board_controls.dart';
import 'package:flutter_music/music_player_panel//now_playing/music_img_container.dart';
import 'package:flutter_music/music_player_panel//now_playing/preferences_board.dart';
import 'package:flutter_music/music_player_panel/now_playing/empty_music_img.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class NowPlayingScreen extends StatefulWidget {
  final PanelController _controller;

  NowPlayingScreen({@required PanelController controller})
      : _controller = controller;

  @override
  State<StatefulWidget> createState() {
    return new _NowPlayingScreenState(
      _controller,
    );
  }
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  PanelController _controller;
  Global _musicPlayer;

  _NowPlayingScreenState(
    this._controller,
  );

  @override
  void initState() {
    super.initState();
    _musicPlayer = Global();
  }

  @override
  Widget build(BuildContext context) {
    final double _radius = 25.0;
    final double _screenHeight = MediaQuery.of(context).size.height;
    final double _musicImgSize = _screenHeight / 2.1;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: _musicImgSize + 50,
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                _musicPlayer.hasImg
                    ? MusicImgContainer(musicPlayer: _musicPlayer)
                    : EmptyMusicImgContainer(iconSize: _musicImgSize / 2),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: MusicBoardControls(musicPlayer: _musicPlayer),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.transparent,
            height: _screenHeight / 15,
          ),
          PreferencesBoard(musicPlayer: _musicPlayer),
          Divider(
            color: Colors.transparent,
            height: _screenHeight / 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 12,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _musicPlayer.title.toUpperCase(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFADB9CD),
                            letterSpacing: 1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Divider(
                          height: 5,
                          color: Colors.transparent,
                        ),
                        Text(
                          _musicPlayer.title,
                          style: TextStyle(
                            fontSize: 30,
                            color: Color(0xFF4D6B9C),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () => _controller.close(),
                    child: Container(
                      width: 32.0,
                      height: 32.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Color(0xFF90A4D4),
                        ),
                        borderRadius: BorderRadius.circular(
                          _radius,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF90A4D4),
                          size: 22.0,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(
            color: Colors.transparent,
            height: _screenHeight / 22,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: <Widget>[
                Container(
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
                          max: _musicPlayer.duration.inMilliseconds.toDouble(),
                          value: _musicPlayer.duration.inMilliseconds >
                                  _musicPlayer.position.inMilliseconds
                              ? _musicPlayer.position.inMilliseconds.toDouble()
                              : _musicPlayer.duration.inMilliseconds.toDouble(),
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
                          activeColor: Colors.blue,
                          inactiveColor: Color(0xFFCEE3EE),
                        ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child:
                            !_musicPlayer.isStopped || _musicPlayer.hasPosition
                                ? new Text(
                                    '${_musicPlayer.positionText ?? '0:00'}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFADB9CD),
                                      letterSpacing: 1,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : new Text(
                                    '0:00',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFADB9CD),
                                      letterSpacing: 1,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(width: double.infinity),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: _musicPlayer.hasDuration
                            ? new Text(
                                '${_musicPlayer.durationText ?? '0:00'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFADB9CD),
                                  letterSpacing: 1,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : new Text(
                                '0:00',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFADB9CD),
                                  letterSpacing: 1,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
