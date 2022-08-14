import 'dart:convert';
import './song.dart';

class Album {
  String imageURL;
  String name;
  String artist_name;
  String release_year;
  List<Song> tracklist;
  Album(this.imageURL, this.name, this.artist_name, this.release_year,
      this.tracklist);
  factory Album.fromJson(String jsonAsString) {
    Map<String, dynamic> albumData = jsonDecode(jsonAsString);
    List songJson = albumData['tracks']['items'];
    return Album(
        albumData['images'][1]['url'],
        albumData['name'],
        albumData['artists'][0]['name'],
        albumData['release_date_precision'] == 'year'
            ? albumData['release_date']
            : DateTime.parse(albumData['release_date']).year.toString(),
        List.generate(
            songJson.length,
            (index) =>
                Song(songJson[index]['name'], songJson[index]['duration_ms'])));
  }
}
