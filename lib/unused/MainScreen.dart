import 'dart:async';
import 'dart:io' show Platform;

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/component/audio_service/AudioPlayerTask.dart';
import 'package:flutter_application_1/component/audio_service/MediaState.dart';
import 'package:flutter_application_1/component/audio_service/QueueState.dart';
import 'package:flutter_application_1/component/audio_service/TextPlayerTask.dart';
import 'package:flutter_application_1/component/player/SeekBar.dart';
import 'package:rxdart/rxdart.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Service Demo'),
      ),
      body: Center(
        child: StreamBuilder<bool>(
          stream: AudioService.runningStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.active) {
              // Don't show anything until we've ascertained whether or not the
              // service is running, since we want to show a different UI in
              // each case.
              return SizedBox();
            }
            final running = snapshot.data ?? false;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!running) ...[
                  // UI to show when we're not running, i.e. a menu.
                  audioPlayerButton(),
                  if (kIsWeb || !Platform.isMacOS) textToSpeechButton(),
                ] else ...[
                  // UI to show when we're running, i.e. player state/controls.

                  // Queue display/controls.
                  StreamBuilder<QueueState>(
                    stream: _queueStateStream,
                    builder: (context, snapshot) {
                      final queueState = snapshot.data;
                      final queue = queueState?.queue ?? [];
                      final mediaItem = queueState?.mediaItem;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (queue.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.skip_previous),
                                  iconSize: 64.0,
                                  onPressed: mediaItem == queue.first
                                      ? null
                                      : AudioService.skipToPrevious,
                                ),
                                IconButton(
                                  icon: Icon(Icons.skip_next),
                                  iconSize: 64.0,
                                  onPressed: mediaItem == queue.last
                                      ? null
                                      : AudioService.skipToNext,
                                ),
                              ],
                            ),
                          if (mediaItem?.title != null) Text(mediaItem!.title),
                        ],
                      );
                    },
                  ),
                  // Play/pause/stop buttons.
                  StreamBuilder<bool>(
                    stream: AudioService.playbackStateStream
                        .map((state) => state.playing)
                        .distinct(),
                    builder: (context, snapshot) {
                      final playing = snapshot.data ?? false;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (playing) pauseButton() else playButton(),
                          stopButton(),
                        ],
                      );
                    },
                  ),
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
                  // Display the processing state.
                  StreamBuilder<AudioProcessingState>(
                    stream: AudioService.playbackStateStream
                        .map((state) => state.processingState)
                        .distinct(),
                    builder: (context, snapshot) {
                      final processingState =
                          snapshot.data ?? AudioProcessingState.none;
                      return Text(
                          "Processing state: ${describeEnum(processingState)}");
                    },
                  ),
                  // Display the latest custom event.
                  StreamBuilder(
                    stream: AudioService.customEventStream,
                    builder: (context, snapshot) {
                      return Text("custom event: ${snapshot.data}");
                    },
                  ),
                  // Display the notification click status.
                  StreamBuilder<bool>(
                    stream: AudioService.notificationClickEventStream,
                    builder: (context, snapshot) {
                      return Text(
                        'Notification Click Status: ${snapshot.data}',
                      );
                    },
                  ),
                ],
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

  ElevatedButton audioPlayerButton() => startButton(
        'AudioPlayer',
        () {
          AudioService.start(
            backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
            androidNotificationChannelName: 'Audio Service Demo',
            // Enable this if you want the Android service to exit the foreground state on pause.
            //androidStopForegroundOnPause: true,
            androidNotificationColor: 0xFF2196f3,
            androidNotificationIcon: 'mipmap/ic_launcher',
            androidEnableQueue: true,
          );
        },
      );

  ElevatedButton textToSpeechButton() => startButton(
        'TextToSpeech',
        () {
          AudioService.start(
            backgroundTaskEntrypoint: _textToSpeechTaskEntrypoint,
            androidNotificationChannelName: 'Audio Service Demo',
            androidNotificationColor: 0xFF2196f3,
            androidNotificationIcon: 'mipmap/ic_launcher',
          );
        },
      );

  ElevatedButton startButton(String label, VoidCallback onPressed) =>
      ElevatedButton(
        child: Text(label),
        onPressed: onPressed,
      );

  IconButton playButton() => IconButton(
        icon: Icon(Icons.play_arrow),
        iconSize: 64.0,
        onPressed: AudioService.play,
      );

  IconButton pauseButton() => IconButton(
        icon: Icon(Icons.pause),
        iconSize: 64.0,
        onPressed: AudioService.pause,
      );

  IconButton stopButton() => IconButton(
        icon: Icon(Icons.stop),
        iconSize: 64.0,
        onPressed: AudioService.stop,
      );
}

void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

// NOTE: Your entrypoint MUST be a top-level function.
void _textToSpeechTaskEntrypoint() async {
  AudioServiceBackground.run(() => TextPlayerTask());
}
