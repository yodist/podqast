import 'package:flutter/material.dart';
import 'package:flutter_application_1/Podcast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:global_configuration/global_configuration.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Map<String, dynamic>> futureBestPod;
  List<Widget> myCardList;

  @override
  void initState() {
    super.initState();
    futureBestPod = fetchBestPodcasts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          title: Image(
            image: AssetImage('assets/image/PodQast.png'),
            height: 35,
          ),
          backgroundColor: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(15, 10, 0, 10),
              child: Text(
                "Top Podcasts",
                style: GoogleFonts.robotoCondensed(
                    fontSize: 28, fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.centerLeft,
            ),
            Container(
              height: 160.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  FutureBuilder(
                      future: futureBestPod,
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: snapshot.data['podcasts'].length,
                                itemBuilder: (_, int position) {
                                  final item =
                                      snapshot.data['podcasts'][position];
                                  return InkWell(
                                    splashColor: Colors.blue.withAlpha(30),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Podcast(
                                                  title: "PodQast",
                                                )),
                                      );
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: Image(
                                              image:
                                                  NetworkImage(item['image']),
                                            ),
                                          ),
                                          width: 160.0,
                                          margin:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>> fetchBestPodcasts() async {
  final response = await http.get(
      'https://listen-api-test.listennotes.com/api/v2/best_podcasts',
      headers: {
        'X-ListenAPI-Key': GlobalConfiguration().getValue("listenKey")
      });

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return jsonDecode(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load best podcast');
  }
}
