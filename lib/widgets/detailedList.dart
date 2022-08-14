// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:http_practice/routes/albumCoverRoute.dart';

import '../models/album.dart';

class DetailedList extends StatefulWidget {
  List<Album> albums;
  DetailedList({
    Key? key,
    required this.albums,
  }) : super(key: key);

  @override
  State<DetailedList> createState() => _DetailedListState();
}

class _DetailedListState extends State<DetailedList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: widget.albums.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => AlbumCoverRoute(
                            loadedAlbum: widget.albums[index]))));
              },
              child: Container(
                color: Color.fromARGB(198, 60, 219, 105),
                height: 100,
                margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Row(children: [
                  Image.network(widget.albums[index].imageURL),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            widget.albums[index].name,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(widget.albums[index].artist_name)
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            );
          }),
    );
  }
}
