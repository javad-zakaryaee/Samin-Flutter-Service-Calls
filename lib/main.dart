import 'package:flutter/material.dart';

import 'package:http_practice/widgets/detailedList.dart';

import './spotifyAuth/spotifyAuth.dart';
import './models/album.dart';
import './routes/tracklistRoute.dart';

void main() => runApp(const MyMaterialApp());

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Http Practice',
      theme: ThemeData(
          colorScheme: const ColorScheme(
              background: Colors.black,
              onSurface: Color(0xff3cdb69),
              onBackground: Colors.amber,
              brightness: Brightness.dark,
              primary: Color.fromARGB(242, 60, 219, 105),
              error: Colors.red,
              secondary: Colors.blue,
              surface: Colors.deepPurple,
              onPrimary: Colors.white,
              onError: Colors.white60,
              onSecondary: Colors.lightBlue),
          appBarTheme: const AppBarTheme(
              color: Color(0xff121212),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 16))),
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
  late String access_token;
  bool isAlbumListLoaded = false;
  final formKey = GlobalKey<FormState>();
  final albumController = TextEditingController();
  late List<Album> albumList;
  void setTextData(String input) {
    setState(() {
      textData = input;
    });
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text(" Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JSON over HTTP'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Container(
                margin: EdgeInsets.only(bottom: 10, left: 5, right: 5),
                child: TextFormField(
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Can\'t be empty' : null,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter album keyword'),
                  controller: albumController,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      showLoaderDialog(context);
                      getAcessToken().then((token) async {
                        access_token = token;
                        print('token received');
                        albumList =
                            await getSearchResults(token, albumController.text)
                                .then((value) {
                          setState(() {
                            isAlbumListLoaded = true;
                            Navigator.pop(context);
                          });
                          return value;
                        });
                        setTextData('Token received');
                      }).onError((error, stackTrace) {
                        setState(() {
                          isAlbumListLoaded = false;
                        });
                        Navigator.pop(context);
                        setTextData(error.toString());
                      });
                    } else {
                      setState(() {
                        isAlbumListLoaded = false;
                      });
                    }
                  },
                  child: const Text('Search for album')),
            ),
            isAlbumListLoaded ? DetailedList(albums: albumList) : Text(textData)
          ],
        ),
      ),
    );
  }
}
