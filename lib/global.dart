import 'music_player.dart';

class Global extends MusicPlayer {
  static MusicPlayer _instance;
  static String musicUrl;
  static String musicTitle;

  factory Global({String url, String title}) {
    if (_instance == null) {
      musicUrl = url;
      musicTitle = title;
      _instance = new Global._();
    }
    if (url == null || title == null) return _instance;
    _instance.url = url;
    _instance.title = title;
    return _instance;
  }

  Global._() : super(url: musicUrl, title: musicTitle);

  bool isAudioPlaying() {
    if (audioPlayer == null) return false;
    return true;
  }
}
