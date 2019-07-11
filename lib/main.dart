import 'package:flutter/material.dart';
import 'package:flutter_music/SecondRoute.dart';

import 'global.dart';
import 'music_player_panel.dart';

typedef void OnError(Exception exception);

void main() {
  runApp(new MaterialApp(home: new SoundApp()));
}

class SoundApp extends StatefulWidget {
  @override
  _SoundAppState createState() => new _SoundAppState();
}

class _SoundAppState extends State<SoundApp> {
  Global _musicPlayer = Global();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: Column(
        children: <Widget>[
          Center(
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
          panel(),
        ],
      ),
    );
  }

  Widget panel() {
    if (!_musicPlayer.isStopped)
      return Container(
        child: MusicPlayerPanel(),
      );
    return Container();
  }
}
