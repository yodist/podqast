import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:podqast/screens/podcast_list_page.dart';
import 'package:podqast/service/podcast_service.dart';

class PodcastResultPage extends StatefulWidget {
  const PodcastResultPage(this.suggestion, {Key? key}) : super(key: key);

  final String suggestion;

  @override
  _PodcastResultPageState createState() => _PodcastResultPageState();
}

class _PodcastResultPageState extends State<PodcastResultPage> {
  PodcastService podcastService = new PodcastService();

  late Future<List<Map<String, dynamic>>> podcastData;

  @override
  void initState() {
    super.initState();

    podcastData = podcastService.searchPodcasts(widget.suggestion);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        navigationBar: CupertinoNavigationBar(
          middle: Image(
            image: AssetImage('assets/image/PodQast.png'),
            height: 35,
          ),
          backgroundColor: Colors.white,
          transitionBetweenRoutes: false,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FutureBuilder(
                  future: podcastData,
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: (snapshot.data! as List).length,
                            itemBuilder: (_, int position) {
                              var snapshotData = (snapshot.data! as List);
                              final item = snapshotData[position];

                              return Material(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PodcastListPage(
                                                  item['id'],
                                                  title: item['title_original'],
                                                  imageUrl: item['image'],
                                                  publisher: item[
                                                      'publisher_original'],
                                                )));
                                  },
                                  child: Card(
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.0),
                                      child: ListTile(
                                        leading: Image.network(item['image']),
                                        title: Html(
                                            data: item['title_highlighted'],
                                            style: {
                                              "*": Style(
                                                  fontSize: FontSize.large),
                                              ".ln-search-highlight": Style(
                                                  backgroundColor:
                                                      Colors.amber),
                                            }),
                                        subtitle:
                                            Text(item['publisher_original']),
                                      ),
                                    ),
                                  ),
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
        ));
  }
}
