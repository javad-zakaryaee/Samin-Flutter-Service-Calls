import 'package:flutter/material.dart';
import 'package:http_practice/routes/tracklistRoute.dart';

import '../models/album.dart';

class AlbumCoverRoute extends StatefulWidget {
  final Album loadedAlbum;
  AlbumCoverRoute({Key? key, required this.loadedAlbum}) : super(key: key);

  @override
  State<AlbumCoverRoute> createState() => _AlbumCoverRouteState();
}

class _AlbumCoverRouteState extends State<AlbumCoverRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Album Details'),
        centerTitle: true,
      ),
      body: Center(
        child: GestureDetector(
          onTap: (() {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) =>
                        TrackListRoute(album: widget.loadedAlbum))));
          }),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: Color.fromARGB(201, 5, 116, 48),
            elevation: 10,
            child: SizedBox(
                height: 400,
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      child: Hero(
                        tag: 'coverArt',
                        child: Image.network(
                          widget.loadedAlbum.imageURL,
                          fit: BoxFit.fill,
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
                    Text(
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      widget.loadedAlbum.name,
                      textAlign: TextAlign.center,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.loadedAlbum.artist_name,
                              style: TextStyle(fontSize: 14)),
                        ),
                        Text(
                          widget.loadedAlbum.release_year,
                        )
                      ],
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
