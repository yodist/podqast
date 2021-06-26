import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:podqast/service/podcast_service.dart';
import 'package:podqast/widgets/podcast_block.dart';

class PodcastHomeTab extends StatefulWidget {
  @override
  _PodcastHomeTabState createState() => _PodcastHomeTabState();
}

class _PodcastHomeTabState extends State<PodcastHomeTab>
    with AutomaticKeepAliveClientMixin<PodcastHomeTab> {
  PodcastService podcastService = PodcastService();
  late Future<Map<String, dynamic>> data;

  @override
  void initState() {
    super.initState();

    data = podcastService.fetchBestPodcasts();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          heroTag: 'tab1',
          transitionBetweenRoutes: false,
          middle: Image(
            image: AssetImage('assets/image/PodQast.png'),
            height: 35,
          ),
          backgroundColor: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(15, 10, 0, 10),
              child: Text(
                "Top Podcasts",
                style: TextStyle(fontSize: 28),
              ),
              alignment: Alignment.centerLeft,
            ),
            Container(
              alignment: Alignment.topLeft,
              height: 250.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  FutureBuilder(
                      future: data,
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount:
                                    (snapshot.data! as Map)['podcasts'].length,
                                itemBuilder: (_, int position) {
                                  var snapshotData = (snapshot.data! as Map);
                                  final item =
                                      snapshotData['podcasts'][position];
                                  return podcastBlock(context, item['id'],
                                      item['image'], item['title'],
                                      publisher: item['publisher'],
                                      description: item['description'],
                                      genreIds: item['genreIds']);
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
        ));
  }
}
