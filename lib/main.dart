import 'package:flutter/material.dart';
import 'package:flutter_music/SecondRoute.dart';
import 'package:flutter_music/music_player_panel/bottom_player_panel.dart';
import 'package:media_notification/media_notification.dart';

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

class _MusicAppState extends State<MusicApp> with WidgetsBindingObserver {
  Global _musicPlayer;
  AppLifecycleState _notification;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
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
  void deactivate() {
    _musicPlayer.hideNotification();
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
      if (_notification == AppLifecycleState.inactive) {
        print(AppLifecycleState.inactive);
      } else if (_notification == AppLifecycleState.resumed) {
        print(AppLifecycleState.resumed);
      } else if (_notification == AppLifecycleState.paused) {
        print(AppLifecycleState.paused);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomPlayerPanel(fatherWidget: body(context));
  }

  Widget body(context) {
    return Scaffold(
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
    );
  }
}
