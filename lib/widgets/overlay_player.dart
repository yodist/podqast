import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:podqast/model/media_state.dart';
import 'package:podqast/model/queue_state.dart';
import 'package:podqast/screens/player_page2.dart';
import 'package:podqast/widgets/player/audio_control.dart';
import 'package:podqast/widgets/player/seek_bar.dart';
import 'package:rxdart/rxdart.dart';

class OverlayPlayer extends StatelessWidget {
  const OverlayPlayer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SafeArea(
        // child: ListTile(
        //   leading: SizedBox.fromSize(size: const Size(20, 20)),
        //   title: Text('Boyan'),
        //   subtitle: Text('Test'),
        //   trailing: IconButton(icon: Icon(CupertinoIcons.play), onPressed: () {}),
        // ),
        child: StreamBuilder<bool>(
          stream: AudioService.runningStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.active) {
              return CircularProgressIndicator();
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<QueueState>(
                  stream: _queueStateStream,
                  builder: (context, snapshot) {
                    final queueState = snapshot.data;
                    final mediaItem = queueState?.mediaItem;
                    final artwork = mediaItem?.artUri.toString();
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlayerPage2()),
                        );
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        minVerticalPadding: 0,
                        leading: artwork == null
                            ? Image.asset(
                                'assets/image/PodQast.png',
                                fit: BoxFit.fitHeight,
                              )
                            : CachedNetworkImage(
                                fit: BoxFit.fitHeight,
                                imageUrl: artwork,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.grey.shade200),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                        title: Text(
                          mediaItem?.title ?? "No Title",
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                        ),
                        subtitle: Text(
                          mediaItem?.album ?? "No Album",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: StreamBuilder<PlaybackState>(
                          stream: AudioService.playbackStateStream,
                          builder: (context, snapshot) {
                            final state = snapshot.data;
                            final playing = state?.playing ?? false;
                            final completed = state?.processingState ==
                                AudioProcessingState.completed;
                            final buffering = state?.processingState ==
                                AudioProcessingState.buffering;
                            return SizedBox(
                              width: 60,
                              height: 60,
                              child: Center(
                                child: buffering
                                    ? CupertinoActivityIndicator()
                                    : playing
                                        ? AudioControl.miniPauseButton()
                                        : completed
                                            ? AudioControl.miniReplayButton()
                                            : AudioControl.miniPlayButton(),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                // Play/pause/stop buttons.

                // A seek bar.
                StreamBuilder<MediaState>(
                  stream: _mediaStateStream,
                  builder: (context, snapshot) {
                    final mediaState = snapshot.data;
                    return SeekBar(
                      duration:
                          mediaState?.mediaItem?.duration ?? Duration.zero,
                      position: mediaState?.position ?? Duration.zero,
                      onChangeEnd: (newPosition) {
                        AudioService.seekTo(newPosition);
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// A stream reporting the combined state of the current media item and its
  /// current position.
  Stream<MediaState> get _mediaStateStream =>
      Rx.combineLatest2<MediaItem?, Duration, MediaState>(
          AudioService.currentMediaItemStream,
          AudioService.positionStream,
          (mediaItem, position) => MediaState(mediaItem, position));

  /// A stream reporting the combined state of the current queue and the current
  /// media item within that queue.
  Stream<QueueState> get _queueStateStream =>
      Rx.combineLatest2<List<MediaItem>?, MediaItem?, QueueState>(
          AudioService.queueStream,
          AudioService.currentMediaItemStream,
          (queue, mediaItem) => QueueState(queue, mediaItem));
}
