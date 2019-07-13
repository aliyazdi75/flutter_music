import 'package:flutter/material.dart';
import 'package:flutter_music/global.dart';

class MusicImgContainer extends StatelessWidget {
  const MusicImgContainer({
    Key key,
    @required Global musicPlayer,
  })  : _musicPlayer = musicPlayer,
        super(key: key);

  final Global _musicPlayer;

  @override
  Widget build(BuildContext context) {
    final double _radius = 25.0;
    final double _screenHeight = MediaQuery.of(context).size.height;
    final double _musicImgSize = _screenHeight / 2.1;

    return ClipRRect(
      borderRadius: BorderRadius.circular(_radius),
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: _musicImgSize,
            child: FadeInImage(
              placeholder: _musicPlayer.musicImg(),
              image: _musicPlayer.musicImg(),
              fit: BoxFit.fill,
            ),
          ),
          Opacity(
            opacity: 0.55,
            child: Container(
              width: double.infinity,
              height: _musicImgSize,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [
                    0.0,
                    0.85,
                  ],
                  colors: [
                    Color(0xFF47ACE1),
                    Color(0xFFDF5F9D),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
