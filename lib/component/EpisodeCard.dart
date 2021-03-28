import 'package:flutter/material.dart';
import 'package:flutter_application_1/PlayerPage.dart';
import 'package:flutter_application_1/PodcastDetailPage.dart';
import 'package:flutter_application_1/util/StringUtil.dart';
import 'package:google_fonts/google_fonts.dart';

class EpisodeCard extends StatelessWidget {
  EpisodeCard(
    this.episodeId, {
    Key? key,
    required this.iconUrl,
    required this.podcastTitle,
    required this.title,
    this.subtitle = "",
    required this.imageUrl,
    required this.duration,
    required this.releaseDate,
    this.publisher = "",
    this.fileSize = "0 MB",
  }) : super(key: key);

  final String episodeId;
  final String iconUrl;
  final String imageUrl;
  final String podcastTitle;
  final String title;
  final String subtitle;
  final String releaseDate;
  final String duration;
  final String publisher;
  final String fileSize;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PodcastDetailPage(
                      this.episodeId,
                      title: this.title,
                      description: this.subtitle,
                      imageUrl: this.imageUrl,
                      publisher: this.publisher,
                      podcastTitle: this.podcastTitle,
                      releaseDate: this.releaseDate,
                      duration: this.duration,
                      fileSize: this.fileSize,
                    )),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 10),
            ListTile(
              leading: Image(
                image: NetworkImage(iconUrl),
              ),
              title: Text(title),
              subtitle: Text(
                StringUtil.parseHtmlString(subtitle),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 5),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Text(
                  this.releaseDate,
                  style: GoogleFonts.robotoCondensed(
                      fontSize: 16, color: Colors.black),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  this.duration,
                  style: GoogleFonts.robotoCondensed(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10,
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.play_circle_outline,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlayerPage()),
                    );
                  },
                ),
                SizedBox(
                  width: 20,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
