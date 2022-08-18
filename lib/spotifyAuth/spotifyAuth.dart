import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/album.dart';
import 'token.dart';

Future<String> getAcessToken() async {
  Map grantType = {'grant_type': 'client_credentials'};
  Map<String, String> requestHeaders = {
    'Content-type': 'application/x-www-form-urlencoded',
    'Authorization': 'Basic ${token}'
  };
  Map<String, dynamic> responseBody = {};
  var accessToken;
  await http
      .post(Uri.parse('https://accounts.spotify.com/api/token'),
          body: grantType, headers: requestHeaders)
      .then((response) {
    if (response.statusCode == 200) {
      responseBody = jsonDecode(response.body);
      accessToken = responseBody['access_token'];
    } else {
      Future.error(Exception('Auth Error : ${response.statusCode}'));
    }
  });
  return accessToken;
}

Future<List<Album>> getSearchResults(String accessToken, String query) async {
  List<Album> queryResult = [];
  List<String> albumIDs;
  var responseBody;
  query = Uri.encodeFull(query);
  print(query);
  await http.get(
      Uri.parse(
          'https://api.spotify.com/v1/search?q=$query&type=album&limit=10'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      }).then((response) async {
    if (response.statusCode == 200) {
      responseBody = jsonDecode(response.body);
      albumIDs = List.generate(responseBody['albums']['items'].length, (index) {
        return responseBody['albums']['items'][index]['id'];
      });
      for (String i in albumIDs) {
        var album = await getAlbumData(accessToken, i);
        queryResult.add(album);
      }
    } else {
      return Future.error(response.statusCode);
    }
  });
  return queryResult;
}

Future<Album> getAlbumData(String accessToken, String albumID) async {
  Album? album;
  await http.get(Uri.parse('https://api.spotify.com/v1/albums/$albumID'),
      headers: {'Authorization': 'Bearer $accessToken}'}).then((response) {
    if (response.statusCode == 200) {
      album = Album.fromJson(response.body);
      //return album;
    } else {
      return Future.error(Exception('Album error : ${response.statusCode}'));
    }
  });
  return Future.value(album);
}
