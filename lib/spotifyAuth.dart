import 'package:http/http.dart' as http;
import 'dart:convert';
import './album.dart';

Future<String> getAcessToken() async {
  Map grant_type = {'grant_type': 'client_credentials'};
  Map<String, String> requestHeaders = {
    'Content-type': 'application/x-www-form-urlencoded',
    'Authorization':
        'Basic NGFhYWVjZjk2MjY5NDJkZWIyZTkzOGQ2OGMzYWVkNWE6OWFkMmEwZWVhNTkxNDlkNmI2OGFjODU4MzBkYzdiODU='
  };
  Map<String, dynamic> responseBody = {};
  var access_token;
  await http
      .post(Uri.parse('https://accounts.spotify.com/api/token'),
          body: grant_type, headers: requestHeaders)
      .then((response) {
    if (response.statusCode == 200) {
      responseBody = jsonDecode(response.body);
      access_token = responseBody['access_token'];
    }
  });
  return access_token;
}

Future<Album> getAlbumData(String accessToken) async {
  Album? album;
  await http.get(
      Uri.parse('https://api.spotify.com/v1/albums/2WT1pbYjLJciAR26yMebkH'),
      headers: {'Authorization': 'Bearer $accessToken}'}).then((response) {
    if (response.statusCode == 200) {
      album = Album.fromJson(response.body);
      //return album;
    } else {
      return Future.error(Exception(response.statusCode));
    }
  });
  return Future.value(album);
}
