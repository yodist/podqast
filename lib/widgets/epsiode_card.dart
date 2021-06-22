import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/main_provider.dart';
import 'package:flutter_application_1/screens/player_page2.dart';
import 'package:flutter_application_1/screens/podcast_detail_page.dart';
import 'package:flutter_application_1/util/string_util.dart';
import 'package:provider/provider.dart';

class EpisodeCard extends StatelessWidget {
  EpisodeCard(this.episodeId,
      {Key? key,
      required this.iconUrl,
      required this.podcastTitle,
      required this.title,
      this.subtitle = "",
      required this.imageUrl,
      required this.duration,
      required this.durationDur,
      required this.releaseDate,
      this.publisher = "",
      this.fileSize = "0 MB",
      required this.audioUri})
      : super(key: key);

  final String episodeId;
  final String iconUrl;
  final String imageUrl;
  final String podcastTitle;
  final String title;
  final String subtitle;
  final String releaseDate;
  final String duration;
  final Duration durationDur;
  final String publisher;
  final String fileSize;
  final String audioUri;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
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
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  this.duration,
                  style: TextStyle(
                      fontSize: 14,
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
                  onPressed: () async {
                    context.read<MainProvider>().showPlayer();
                    List<MediaItem> playlist = <MediaItem>[
                      MediaItem(
                        // This can be any unique id, but we use the audio URL for convenience.
                        id: this.audioUri,
                        album: this.title,
                        title: this.podcastTitle,
                        artist: this.publisher,
                        duration: durationDur,
                        artUri: Uri.parse(this.imageUrl),
                      ),
                    ];
                    await AudioService.updateQueue(playlist);
                    await AudioService.skipToQueueItem(playlist[0].id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlayerPage2()),
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
