import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/PodcastController.dart';

class PodcastListPage extends StatefulWidget {
  PodcastListPage(this.id,
      {Key key,
      this.title,
      this.imageUrl,
      this.publisher,
      this.genre,
      this.description})
      : super(key: key);

  final String id;
  final String title;
  final String imageUrl;
  final String publisher;
  final String genre;
  final String description;

  @override
  _PodcastListPageState createState() => _PodcastListPageState();
}

class _PodcastListPageState extends State<PodcastListPage> {
  Future<Map<String, dynamic>> podcastEpisodeList;
  String title = "";
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    podcastEpisodeList = fetchPodcastListById(widget.id);
    title = widget.title;
    imageUrl = widget.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: ClipRRect(
                child: Image(
                  image: NetworkImage(imageUrl),
                ),
              ),
            )
          ],
        ));
  }
}
