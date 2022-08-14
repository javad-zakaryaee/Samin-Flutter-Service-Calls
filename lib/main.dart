import 'package:flutter/material.dart';
import './album.dart';
import './spotifyAuth.dart';

void main() => runApp(MyMaterialApp());

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Http Practice',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white, //<-- SEE HERE
              displayColor: Colors.white,
            ),
        appBarTheme:
            AppBarTheme(titleTextStyle: TextStyle(color: Colors.white)),
        primarySwatch: Colors.cyan,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var textData = '';
  bool isAlbumLoaded = false;
  late Album loadedAlbum;
  void setTextData(String input) {
    setState(() {
      textData = input;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('JSON over HTTP'), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Visibility(
            visible: !isAlbumLoaded,
            child: Column(
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                    onPressed: () {
                      getAcessToken().then((accessToken) {
                        getAlbumData(accessToken).then((value) {
                          loadedAlbum = value;
                          setState(() {
                            isAlbumLoaded = true;
                          });
                        });
                      });
                    },
                    child: Text('Get album data')),
                Text(textData)
              ],
            ),
          ),
          if (isAlbumLoaded)
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              color: Theme.of(context).primaryColor,
              elevation: 10,
              child: SizedBox(
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 100,
                          child: Image.network(
                            loadedAlbum.imageURL,
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
                        Column(
                          children: [
                            Text(
                              loadedAlbum.name,
                              textAlign: TextAlign.center,
                            ),
                            Text(loadedAlbum.release_year)
                          ],
                        )
                      ],
                    ),
                  )),
            )
        ],
      ),
    );
  }
}
