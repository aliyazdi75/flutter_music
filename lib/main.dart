import 'package:flutter/material.dart';
import 'package:flutter_music/SecondRoute.dart';
import 'package:flutter_music/music_player_panel/music_player_panel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'global.dart';

typedef void OnError(Exception exception);

void main() {
  runApp(
      new MaterialApp(debugShowCheckedModeBanner: false, home: new MusicApp()));
}

class MusicApp extends StatefulWidget {
  @override
  _MusicAppState createState() => new _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  PanelController _panelController;
  Global _musicPlayer;

  @override
  void initState() {
    _panelController = PanelController();
    _musicPlayer = Global();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _musicPlayer.isStopped
        ? Scaffold(
            appBar: AppBar(
              title: Text('First Route'),
            ),
            body: Center(
              child: RaisedButton(
                child: Text('Open route'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondRoute()),
                  );
                },
              ),
            ),
          )
        : MusicPlayerPanel(panelController: _panelController);
  }
}
