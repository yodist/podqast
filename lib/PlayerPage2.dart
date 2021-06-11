import 'dart:async';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter/widgets.dart';

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
                                children: [
                                  rewindButton(),
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
                                                      ? pauseButton()
                                                      : completed
                                                          ? replayButton()
                                                          : playButton(),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  fastForwardButton(),
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

  // IconButton playButton() => IconButton(
  //       icon: Icon(Icons.play_arrow_rounded),
  //       iconSize: 48.0,
  //       onPressed: AudioService.play,
  //     );

  // IconButton pauseButton() => IconButton(
  //       icon: Icon(Icons.pause_circle_filled_rounded),
  //       iconSize: 48.0,
  //       onPressed: AudioService.pause,
  //     );

  // IconButton stopButton() => IconButton(
  //       icon: Icon(Icons.stop),
  //       iconSize: 48.0,
  //       onPressed: AudioService.stop,
  //     );

  // IconButton replayButton() => IconButton(
  //       icon: Icon(Icons.replay),
  //       iconSize: 42.0,
  //       onPressed: () async {
  //         await AudioService.seekTo(Duration.zero);
  //         AudioService.play();
  //       },
  //     );

  // IconButton rewindButton() => IconButton(
  //       icon: Icon(Icons.fast_rewind_rounded),
  //       iconSize: 42.0,
  //       onPressed: () => AudioService.rewind(),
  //     );

  // IconButton fastForwardButton() => IconButton(
  //       icon: Icon(Icons.fast_forward_rounded),
  //       iconSize: 42.0,
  //       onPressed: () => AudioService.fastForward(),
  //     );

  CupertinoButton playButton() => CupertinoButton(
        child: Icon(
          Icons.play_arrow_rounded,
          size: 48.0,
        ),
        onPressed: AudioService.play,
      );

  CupertinoButton pauseButton() => CupertinoButton(
        child: Icon(
          Icons.pause_circle_filled_rounded,
          size: 48,
        ),
        onPressed: AudioService.pause,
      );

  CupertinoButton stopButton() => CupertinoButton(
        child: Icon(Icons.stop, size: 48),
        onPressed: AudioService.stop,
      );

  CupertinoButton replayButton() => CupertinoButton(
        child: Icon(
          Icons.replay,
          size: 42,
        ),
        onPressed: () async {
          await AudioService.seekTo(Duration.zero);
          AudioService.play();
        },
      );

  CupertinoButton rewindButton() => CupertinoButton(
        child: Icon(
          Icons.fast_rewind_rounded,
          size: 42,
        ),
        onPressed: () => AudioService.rewind(),
      );

  CupertinoButton fastForwardButton() => CupertinoButton(
        child: Icon(
          Icons.fast_forward_rounded,
          size: 42,
        ),
        onPressed: () => AudioService.fastForward(),
      );
}

class QueueState {
  final List<MediaItem>? queue;
  final MediaItem? mediaItem;

  QueueState(this.queue, this.mediaItem);
}

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  SeekBar({
    required this.duration,
    required this.position,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    final value = min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
        widget.duration.inMilliseconds.toDouble());
    if (_dragValue != null && !_dragging) {
      _dragValue = null;
    }
    return Stack(
      children: [
        SizedBox(
            width: 350,
            height: 40,
            child: CupertinoSlider(
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble() == 0
                  ? 1.0
                  : widget.duration.inMilliseconds.toDouble(),
              value: value,
              onChanged: (value) {
                if (!_dragging) {
                  _dragging = true;
                }
                setState(() {
                  _dragValue = value;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(Duration(milliseconds: value.round()));
                }
              },
              onChangeEnd: (value) {
                if (widget.onChangeEnd != null) {
                  widget.onChangeEnd!(Duration(milliseconds: value.round()));
                }
                _dragging = false;
              },
            )),
        Positioned(
          right: 16.0,
          bottom: 0.0,
          child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                      .firstMatch("$_remaining")
                      ?.group(1) ??
                  '$_remaining',
              style: CupertinoTheme.of(context).textTheme.tabLabelTextStyle),
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}
