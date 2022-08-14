import 'package:flutter/foundation.dart';
import 'dart:convert';

class Album {
  String imageURL;
  String name;
  String artist_name;
  String release_year;
  Album(this.imageURL, this.name, this.artist_name, this.release_year);
  factory Album.fromJson(String jsonAsString) {
    Map<String, dynamic> albumData = jsonDecode(jsonAsString);

    return Album(
        albumData['images'][1]['url'],
        albumData['name'],
        albumData['artists'][0]['name'],
        DateTime.parse(albumData['release_date']).year.toString());
  }
}
