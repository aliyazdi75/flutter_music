import 'music_player.dart';

class Global extends MusicPlayer {
  static MusicPlayer _instance;
  static String musicUrl;
  static String musicTitle;
  static String musicImgUrl;

  factory Global({String url, String title, String imgUrl}) {
    if (_instance == null) {
      musicUrl = url;
      musicTitle = title;
      musicImgUrl = imgUrl;
      _instance = new Global._();
    }
    if (url == null || title == null) return _instance;
    _instance.url = url;
    _instance.title = title;
    _instance.imgUrl = imgUrl;
    return _instance;
  }

  Global._() : super(url: musicUrl, title: musicTitle, imgUrl: musicImgUrl);

  bool isAudioPlaying() {
    if (isStopped) return false;
    return true;
  }
}
