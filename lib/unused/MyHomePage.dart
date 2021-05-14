import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/PodcastService.dart';
import 'package:flutter_application_1/unused/MyCard.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Map<String, dynamic>> futureBestPod;
  PodcastService podcastService = new PodcastService();
  List<Widget> myCardList = [];

  @override
  void initState() {
    super.initState();
    futureBestPod = podcastService.fetchBestPodcasts();
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
                            itemCount:
                                (snapshot.data! as Map)['podcasts'].length,
                            itemBuilder: (_, int position) {
                              var snapshotData = snapshot.data! as Map;
                              final item = snapshotData['podcasts'][position];
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
