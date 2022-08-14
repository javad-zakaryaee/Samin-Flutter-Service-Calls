import 'package:flutter/material.dart';
import 'package:http_practice/widgets/detailedList.dart';
import './routes/tracklistRoute.dart';
import './models/album.dart';
import './spotifyAuth.dart';

void main() => runApp(const MyMaterialApp());

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Http Practice',
      theme: ThemeData(
          colorScheme: ColorScheme(
              background: Colors.black,
              onSurface: Color(0xff3cdb69),
              onBackground: Colors.amber,
              brightness: Brightness.dark,
              primary: Color(0xff3cdb69),
              error: Colors.red,
              secondary: Colors.blue,
              surface: Colors.deepPurple,
              onPrimary: Colors.brown,
              onError: Colors.white60,
              onSecondary: Colors.lightBlue),
          appBarTheme: AppBarTheme(
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
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text(" Loading...")),
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
            Row(
              children: [
                Expanded(
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      validator: (value) => value == null || value.isEmpty
                          ? 'Can\'t be empty'
                          : null,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Enter album keyword'),
                      controller: albumController,
                    ),
                  ),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        showLoaderDialog(context);
                        getAcessToken().then((token) async {
                          access_token = token;
                          albumList = await getSearchResults(
                                  token, albumController.text)
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
                    child: const Text('Get album data')),
              ],
            ),
            isAlbumListLoaded ? DetailedList(albums: albumList) : Text(textData)
          ],
        ),
      ),
    );
  }
}
