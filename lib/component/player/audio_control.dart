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

import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioControl {
  static CupertinoButton playButton() => CupertinoButton(
        child: Icon(
          CupertinoIcons.play_circle,
          size: 48.0,
        ),
        onPressed: AudioService.play,
      );

  static CupertinoButton pauseButton() => CupertinoButton(
        child: Icon(
          CupertinoIcons.pause_circle_fill,
          size: 48,
        ),
        onPressed: AudioService.pause,
      );

  static CupertinoButton stopButton() => CupertinoButton(
        child: Icon(Icons.stop, size: 48.0),
        onPressed: AudioService.stop,
      );

  static CupertinoButton replayButton() => CupertinoButton(
        child: Icon(
          Icons.replay,
          size: 42,
        ),
        onPressed: () async {
          await AudioService.seekTo(Duration.zero);
          AudioService.play();
        },
      );

  static CupertinoButton rewindButton() => CupertinoButton(
        child: Icon(
          CupertinoIcons.backward_fill,
          size: 36.0,
        ),
        onPressed: () => AudioService.rewind(),
      );

  static CupertinoButton fastForwardButton() => CupertinoButton(
        child: Icon(
          CupertinoIcons.forward_fill,
          size: 36.0,
        ),
        onPressed: () => AudioService.fastForward(),
      );

  static CupertinoButton miniPlayButton() => CupertinoButton(
        child: Icon(
          CupertinoIcons.play_circle,
          size: 36.0,
        ),
        onPressed: AudioService.play,
      );

  static CupertinoButton miniPauseButton() => CupertinoButton(
        child: Icon(
          CupertinoIcons.pause_circle_fill,
          size: 36.0,
        ),
        onPressed: AudioService.pause,
      );

  static CupertinoButton miniReplayButton() => CupertinoButton(
        child: Icon(
          Icons.replay,
          size: 36.0,
        ),
        onPressed: () async {
          await AudioService.seekTo(Duration.zero);
          AudioService.play();
        },
      );
}
