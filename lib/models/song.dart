import 'package:flutter/foundation.dart';

class Song {
  String? track_name;
  String? length;

  Song(this.track_name, int length) {
    this.length = formatTime(length);
  }
}

String formatTime(int songDuration) {
  var seconds = Duration(milliseconds: songDuration).inSeconds;
  return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
}
