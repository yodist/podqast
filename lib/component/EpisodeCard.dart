import 'package:flutter/material.dart';
import 'package:flutter_application_1/PodcastDetailPage.dart';
import 'package:google_fonts/google_fonts.dart';

class EpisodeCard extends StatelessWidget {
  EpisodeCard(
      {Key key,
      this.iconUrl,
      this.title,
      this.subtitle,
      this.duration,
      this.releaseDate})
      : super(key: key);

  final String iconUrl;
  final String title;
  final String subtitle;
  final String releaseDate;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PodcastDetailPage()),
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
                subtitle,
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
                  onPressed: () {},
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
