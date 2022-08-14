import 'package:flutter/material.dart';
import 'package:http_practice/models/album.dart';
import 'package:intl/intl.dart';

class TrackListRoute extends StatelessWidget {
  Album album;
  TrackListRoute({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tracklist'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 40, left: 20, right: 20),
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: 180,
                    child: Hero(
                      tag: 'coverArt',
                      child: Image.network(
                        width: 100,
                        album.imageURL,
                        fit: BoxFit.fitHeight,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  ...List.generate(album.tracklist.length, (index) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(0xff3cdb69))),
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${index + 1}. '),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                style: TextStyle(fontSize: 16),
                                album.tracklist[index].track_name ?? '',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(album.tracklist[index].length
                                .toString()
                                .substring(3))
                          ]),
                    );
                  })
                ],
              ),
            ),
          ],
        ));
  }
}
