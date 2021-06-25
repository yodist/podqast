import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/string_util.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:google_fonts/google_fonts.dart';

class PodcastDetailPage extends StatefulWidget {
  PodcastDetailPage(this.id,
      {Key? key,
      this.title = "",
      this.imageUrl = "",
      this.publisher = "",
      this.description = "",
      this.podcastTitle = "",
      this.releaseDate = "",
      this.duration = "",
      this.fileSize = ""})
      : super(key: key);

  final String id;
  final String title;
  final String podcastTitle;
  final String imageUrl;
  final String publisher;
  final String description;
  final String releaseDate;
  final String duration;
  final String fileSize;

  @override
  _PodcastDetailPageState createState() => _PodcastDetailPageState();
}

class _PodcastDetailPageState extends State<PodcastDetailPage> {
  String title = "";
  String imageUrl = "";
  String description = "";
  String publisher = "";
  String podcastTitle = "";
  String releaseDate = "";
  String duration = "";
  String fileSize = "0 MB";

  @override
  void initState() {
    super.initState();
    title = widget.title;
    imageUrl = widget.imageUrl;
    description = widget.description;
    publisher = widget.publisher;
    podcastTitle = widget.podcastTitle;
    releaseDate = widget.releaseDate;
    duration = widget.duration;
    fileSize = widget.fileSize;
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
        child: Column(children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.all(10),
            child: Text(
              StringUtil.parseHtmlString(this.podcastTitle),
              style: GoogleFonts.openSans(
                fontSize: 18,
                color: Colors.purple[800],
              ),
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
          Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
                    this.releaseDate,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    " • ",
                    style: GoogleFonts.robotoCondensed(
                      fontSize: 30,
                      color: Colors.black,
                    ),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    duration,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    softWrap: false,
                  ),
                ],
              )),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.all(10),
            child: Text(
              StringUtil.parseHtmlString(title),
              style: GoogleFonts.openSans(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) => CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.grey.shade200),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.all(5),
            child: Html(
              data: description,
              style: {
                "p": Style(
                  fontSize: FontSize.larger,
                )
              },
            ),
          ),
          Row(
            children: <Widget>[],
          )
        ]),
      ),
    );
  }
}
