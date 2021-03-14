import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/PodcastListPage.dart';
import 'package:google_fonts/google_fonts.dart';

Widget podcastBlock(BuildContext context, String imageUrl, String title,
    {String genre, String publisher}) {
  return InkWell(
    splashColor: Colors.blue.withAlpha(30),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PodcastListPage(
                  title: "PodQast",
                )),
      );
    },
    child: Column(
      children: <Widget>[
        Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image(
              image: NetworkImage(imageUrl),
            ),
          ),
          width: 170.0,
          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
          width: 150.0,
          child: Text(
            title,
            style: GoogleFonts.robotoCondensed(
                fontSize: 18, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
          width: 150.0,
          child: Text(
            publisher != null ? publisher : '',
            style: GoogleFonts.robotoCondensed(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600]),
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
        ),
      ],
    ),
  );
}
