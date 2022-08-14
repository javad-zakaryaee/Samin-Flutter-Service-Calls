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
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(15),
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                      height: 150,
                      child: Hero(
                        tag: 'coverArt',
                        child: Image.network(
                          album.imageURL,
                          fit: BoxFit.fitHeight,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
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
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                child: Text(
                                  album.tracklist[index].track_name ?? '',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(album.tracklist[index].length.toString())
                            ]),
                      );
                    })
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
