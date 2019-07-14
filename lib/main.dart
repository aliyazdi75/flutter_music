import 'package:flutter/material.dart';
import 'package:flutter_music/SecondRoute.dart';
import 'package:flutter_music/global.dart';
import 'package:flutter_music/music_player_panel/music_player_panel.dart';
import 'package:media_notification/media_notification.dart';

void main() {
  runApp(
      new MaterialApp(debugShowCheckedModeBanner: false, home: new MusicApp()));
}

class MusicApp extends StatefulWidget {
  @override
  _MusicAppState createState() => new _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  Global _musicPlayer;

  @override
  void initState() {
    MediaNotification.setListener('pause', () {
      setState(() => _musicPlayer.pauseMusic());
    });

    MediaNotification.setListener('play', () {
      setState(() => _musicPlayer.playMusic());
    });

//    MediaNotification.setListener('select', () {});

    _musicPlayer = Global();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _musicPlayer.closedPanel
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
        : MusicPlayerPanel();
  }
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('First Route'),
//      ),
//      body: Stack(
//        children: <Widget>[
//          Center(
//            child: RaisedButton(
//              child: Text('Open route'),
//              onPressed: () {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => SecondRoute()),
//                );
//              },
//            ),
//          ),
//          MusicPlayerPanel(),
//        ],
//      ),
//    );
//  }
}
