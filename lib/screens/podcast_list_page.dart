import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:podqast/widgets/episode_card.dart';
import 'package:podqast/service/podcast_service.dart';
import 'package:podqast/util/file_util.dart';
import 'package:podqast/util/string_util.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PodcastListPage extends StatefulWidget {
  PodcastListPage(this.id,
      {Key? key,
      this.title = "",
      this.imageUrl = "",
      this.publisher = "",
      this.genreIds,
      this.description = ""})
      : super(key: key);

  final String id;
  final String title;
  final String imageUrl;
  final String publisher;
  final List? genreIds;
  final String description;

  @override
  _PodcastListPageState createState() => _PodcastListPageState();
}

class _PodcastListPageState extends State<PodcastListPage> {
  PodcastService podcastService = new PodcastService();

  late Future<Map<String, dynamic>> podcastData;
  String title = "";
  String imageUrl = "";
  String description = "";
  String publisher = "";

  @override
  void initState() {
    super.initState();
    podcastData = podcastService.fetchPodcastListById(widget.id);

    title = widget.title;
    imageUrl = widget.imageUrl;
    description = widget.description;
    publisher = widget.publisher;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        navigationBar: CupertinoNavigationBar(
          heroTag: 'tab1-1',
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
                    if (snapshot.hasData) {
                      var snapshotData = (snapshot.data! as Map);
                      return Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            width: 150.0,
                            height: 150.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: CachedNetworkImage(
                                imageUrl: snapshotData['image'],
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.grey.shade200),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                width: 200,
                                child: Text(
                                  StringUtil.parseHtmlString(
                                      snapshotData['title']),
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 5,
                                ),
                              ),
                              Container(
                                width: 200,
                                child: Text(
                                  // StringUtil.parseHtmlString(description),
                                  snapshotData['publisher'],
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                ),
                              )
                            ],
                          )
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),

              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.all(10),
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text(
                    "SUBSCRIBE",
                    style: GoogleFonts.robotoCondensed(
                        fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
              FutureBuilder(
                  future: podcastData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Html(
                          data: (snapshot.data! as Map)['description'],
                          style: {"*": Style(fontSize: FontSize.large)},
                        ),
                        // child: Text(
                        //   StringUtil.parseHtmlString(
                        //       (snapshot.data! as Map)['description']),
                        //   style: GoogleFonts.openSans(
                        //       fontSize: 16, color: Colors.black),
                        //   softWrap: false,
                        //   overflow: TextOverflow.ellipsis,
                        //   maxLines: 7,
                        // ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
              FutureBuilder(
                  future: podcastData,
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount:
                                (snapshot.data! as Map)['episodes'].length,
                            itemBuilder: (_, int position) {
                              var snapshotDate = (snapshot.data! as Map);
                              final item = snapshotDate['episodes'][position];
                              String audioUrl = item['audio'];
                              String fileSize =
                                  FileUtil.checkFileSizeFromUri(audioUrl);

                              var dateFormatter = DateFormat("dd MMM ''yy");
                              var releaseDate = dateFormatter.format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      item['pub_date_ms']));
                              var duration = StringUtil.formatDurationHHmm(
                                  item['audio_length_sec']);
                              var durationDur =
                                  Duration(seconds: item['audio_length_sec']);

                              return EpisodeCard(
                                item['id'],
                                iconUrl: item['thumbnail'],
                                imageUrl: item['image'],
                                podcastTitle: this.title,
                                title: item['title'],
                                subtitle: item['description'],
                                releaseDate: releaseDate,
                                duration: duration,
                                durationDur: durationDur,
                                fileSize: fileSize,
                                audioUri: audioUrl,
                              );
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  }),
              // ),
              // ),
              // )
            ],
          ),
        ));
  }
}
