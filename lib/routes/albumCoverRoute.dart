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
            color: Color(0xff3cdb69),
            elevation: 10,
            child: SizedBox(
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 100,
                            child: Hero(
                              tag: 'coverArt',
                              child: Image.network(
                                widget.loadedAlbum.imageURL,
                                fit: BoxFit.fill,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              widget.loadedAlbum.name,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Text(
                          '${widget.loadedAlbum.artist_name} - ${widget.loadedAlbum.release_year}')
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
