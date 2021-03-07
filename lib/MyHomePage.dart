import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:global_configuration/global_configuration.dart';
import 'package:flutter_application_1/MyCard.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.purple[400],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: FutureBuilder(
                  future: futureBestPod,
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data['podcasts'].length,
                            itemBuilder: (_, int position) {
                              final item = snapshot.data['podcasts'][position];
                              return MyCard(
                                iconUrl: item['image'],
                                title: item['title'],
                                subtitle: item['description'],
                              );
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  }),
            )
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
