import 'package:flutter/material.dart';
import 'package:flutter_music/SecondRoute.dart';
import 'package:flutter_music/music_player_panel/bottom_player_panel.dart';
import 'package:flutter_music/music_player_panel/now_playing/now_plaing_screen.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MusicPlayerPanel extends StatelessWidget {
  const MusicPlayerPanel({
    @required PanelController panelController,
  }) : _panelController = panelController;

  final PanelController _panelController;

  @override
  Widget build(BuildContext context) {
    final double _radius = 25.0;
    return WillPopScope(
      onWillPop: () {
        if (!_panelController.isPanelClosed()) {
          _panelController.close();
        }
      },
      child: Scaffold(
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
            child: BottomPlayerPanel(controller: _panelController),
          ),
          body: Scaffold(
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
          ),
        ),
      ),
    );
  }
}
