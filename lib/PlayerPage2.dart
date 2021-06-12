import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/component/player/Player2ControlButtons.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter/widgets.dart';

import 'component/player/SeekBar.dart';
import 'model/MediaState.dart';
import 'model/QueueState.dart';

class PlayerPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Image(
          image: AssetImage('assets/image/PodQast.png'),
          height: 35,
        ),
        backgroundColor: Colors.white,
      ),
      child: Center(
        child: StreamBuilder<bool>(
          stream: AudioService.runningStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.active) {
              // Don't show anything until we've ascertained whether or not the
              // service is running, since we want to show a different UI in
              // each case.
              return SizedBox();
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // UI to show when we're running, i.e. player state/controls.

                // Queue display/controls.
                StreamBuilder<QueueState>(
                  stream: _queueStateStream,
                  builder: (context, snapshot) {
                    final queueState = snapshot.data;
                    final queue = queueState?.queue ?? [];
                    final mediaItem = queueState?.mediaItem;
                    final artwork = mediaItem?.artUri.toString();
                    return Column(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 300,
                              height: 300,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FittedBox(
                                  child: artwork == null
                                      ? Image.asset('assets/image/PodQast.png')
                                      : Image.network(
                                          artwork,
                                        ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              mediaItem?.title ?? "No Title",
                              style: TextStyle(fontSize: 24),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              mediaItem?.album ?? "No Album",
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (queue.isNotEmpty)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: 64.0,
                                      height: 48.0,
                                      child: Center(
                                          child: AudioControl.rewindButton())),
                                  StreamBuilder<PlaybackState>(
                                    stream: AudioService.playbackStateStream,
                                    builder: (context, snapshot) {
                                      final state = snapshot.data;
                                      final playing = state?.playing ?? false;
                                      final completed =
                                          state?.processingState ==
                                              AudioProcessingState.completed;
                                      final buffering =
                                          state?.processingState ==
                                              AudioProcessingState.buffering;
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 64.0,
                                            height: 64.0,
                                            child: Center(
                                              child: buffering
                                                  ? CupertinoActivityIndicator()
                                                  : playing
                                                      ? AudioControl
                                                          .pauseButton()
                                                      : completed
                                                          ? AudioControl
                                                              .replayButton()
                                                          : AudioControl
                                                              .playButton(),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  SizedBox(
                                      width: 64.0,
                                      height: 48.0,
                                      child: Center(
                                          child: AudioControl
                                              .fastForwardButton())),
                                  // replayButton(),
                                ],
                              ),
                          ],
                        )
                      ],
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
                // Debug only for processing state, custom event, and notification click status
                // Display the processing state.
                // StreamBuilder<AudioProcessingState>(
                //   stream: AudioService.playbackStateStream
                //       .map((state) => state.processingState)
                //       .distinct(),
                //   builder: (context, snapshot) {
                //     final processingState =
                //         snapshot.data ?? AudioProcessingState.none;
                //     return Text(
                //         "Processing state: ${describeEnum(processingState)}");
                //   },
                // ),
                // // Display the latest custom event.
                // StreamBuilder(
                //   stream: AudioService.customEventStream,
                //   builder: (context, snapshot) {
                //     return Text("custom event: ${snapshot.data}");
                //   },
                // ),
                // // Display the notification click status.
                // StreamBuilder<bool>(
                //   stream: AudioService.notificationClickEventStream,
                //   builder: (context, snapshot) {
                //     return Text(
                //       'Notification Click Status: ${snapshot.data}',
                //     );
                //   },
                // ),
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
