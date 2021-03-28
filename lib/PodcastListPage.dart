import 'package:flutter/material.dart';
import 'package:flutter_application_1/component/EpisodeCard.dart';
import 'package:flutter_application_1/controller/PodcastController.dart';
import 'package:flutter_application_1/util/FileUtil.dart';
import 'package:flutter_application_1/util/StringUtil.dart';
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
  late Future<Map<String, dynamic>> podcastEpisodeList;
  String title = "";
  String imageUrl = "";
  String description = "";
  String publisher = "";

  @override
  void initState() {
    super.initState();
    podcastEpisodeList = fetchPodcastListById(widget.id);
    title = widget.title;
    imageUrl = widget.imageUrl;
    description = widget.description;
    publisher = widget.publisher;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    width: 150.0,
                    child: ClipRRect(
                      child: Image(
                        image: NetworkImage(imageUrl),
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        width: 200,
                        child: Text(
                          StringUtil.parseHtmlString(title),
                          style: GoogleFonts.openSans(
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
                          publisher,
                          style: GoogleFonts.openSans(
                              fontSize: 18, color: Colors.black),
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                      )
                    ],
                  )
                ],
              ),
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
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Text(
                  StringUtil.parseHtmlString(description),
                  style:
                      GoogleFonts.openSans(fontSize: 16, color: Colors.black),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 7,
                ),
              ),
              // Expanded(
              // child: SizedBox(
              //   height: 200.0,
              // child:
              // Flexible(
              // child:
              FutureBuilder(
                  future: podcastEpisodeList,
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

                              return EpisodeCard(item['id'],
                                  iconUrl: item['thumbnail'],
                                  imageUrl: item['image'],
                                  podcastTitle: this.title,
                                  title: item['title'],
                                  subtitle: item['description'],
                                  releaseDate: releaseDate,
                                  duration: duration,
                                  fileSize: fileSize);
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
