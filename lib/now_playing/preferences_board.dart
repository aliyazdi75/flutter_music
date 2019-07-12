import 'package:flutter/material.dart';
import 'package:flutter_music/global.dart';

class PreferencesBoard extends StatelessWidget {
  const PreferencesBoard({
    Key key,
    @required Global musicPlayer,
  })  : _musicPlayer = musicPlayer,
        super(key: key);

  final Global _musicPlayer;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _musicPlayer.isStopped
          ? Icon(
              Icons.loop,
              size: 35,
              color: Color(0xFFC7D2E3),
            )
          : IconButton(
              onPressed: () {
                _musicPlayer.loop = !_musicPlayer.loop;
              },
              icon: Icon(
                Icons.loop,
                size: 35,
                color:
                    !_musicPlayer.loop ? Color(0xFFC7D2E3) : Color(0xFF7B92CA),
              ),
            ),
    );
  }
}
