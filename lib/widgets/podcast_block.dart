import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:podqast/screens/podcast_list_page.dart';

Widget podcastBlock(
    BuildContext context, String id, String imageUrl, String title,
    {List? genreIds, String publisher = "", String description = ""}) {
  return Material(
      child: InkWell(
    splashColor: Colors.blue.withAlpha(30),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PodcastListPage(
                  id,
                  title: title,
                  imageUrl: imageUrl,
                  publisher: publisher,
                  genreIds: genreIds,
                  description: description,
                )),
      );
    },
    child: Column(
      children: <Widget>[
        Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) => CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Colors.grey.shade200),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          width: 170.0,
          height: 170.0,
          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
          width: 150.0,
          child: Text(
            title,
            style: TextStyle(fontSize: 18.0),
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
          width: 150.0,
          child: Text(
            publisher,
            style: TextStyle(fontSize: 15.0),
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
        ),
      ],
    ),
  ));
}
