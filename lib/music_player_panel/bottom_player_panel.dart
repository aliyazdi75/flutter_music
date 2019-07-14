import 'package:flutter/material.dart';
import 'package:flutter_music/global.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottomPlayerPanel extends StatefulWidget {
  final PanelController _panelController;

  BottomPlayerPanel({@required PanelController panelController})
      : _panelController = panelController;

  @override
  State<StatefulWidget> createState() {
    return new _BottomPlayerPanelState(
      _panelController,
    );
  }
}

class _BottomPlayerPanelState extends State<BottomPlayerPanel> {
  PanelController _panelController;
  Global _musicPlayer;

  _BottomPlayerPanelState(this._panelController);

  @override
  void initState() {
    super.initState();
    _musicPlayer = Global();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Image(
                      image: _musicPlayer.musicImg(),
                      fit: BoxFit.cover,
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
                  flex: 2,
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
                Flexible(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        _musicPlayer.stopMusic(force: true);
                        _musicPlayer.closedPanel = true;
                        _panelController.hide();
                      },
                      child: Center(
                        child: Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 32.0,
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
                  flex: 1,
                  child: !_musicPlayer.isStopped || _musicPlayer.hasPosition
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
                  flex: 12,
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
                          activeColor: Colors.black,
                          inactiveColor: Colors.black.withOpacity(0.5),
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
    );
  }
}
