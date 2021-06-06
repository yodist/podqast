import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/component/player/ControlButtons.dart';
import 'package:flutter_application_1/component/player/SeekBar.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_application_1/model/AudioMetadata.dart';
import 'package:flutter_application_1/model/PositionData.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

MediaControl playControl = MediaControl(
    androidIcon: 'drawable/play_arrow',
    label: 'Play',
    action: MediaAction.play);

MediaControl pauseControl = MediaControl(
    androidIcon: 'drawable/pause', label: 'Play', action: MediaAction.pause);

MediaControl skipToNextControl = MediaControl(
    androidIcon: 'drawable/skip_to_next',
    label: 'Next',
    action: MediaAction.skipToNext);

MediaControl skipToPrevControl = MediaControl(
    androidIcon: 'drawable/skip_to_prev',
    label: 'Previous',
    action: MediaAction.skipToPrevious);

MediaControl stopControl = MediaControl(
    androidIcon: 'drawable/stop', label: 'Stop', action: MediaAction.stop);

class AudioPlayerTask extends BackgroundAudioTask {
  final AudioPlayer audioPlayer;
  AudioPlayerTask(this.audioPlayer);

  final _queue = <MediaItem>[
    MediaItem(
      // This can be any unique id, but we use the audio URL for convenience.
      id: "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
      album: "Science Friday",
      title: "A Salute To Head-Scratching Science",
      artist: "Science Friday and WNYC Studios",
      duration: Duration(milliseconds: 5739820),
      artUri: Uri.parse(
          "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
    ),
    MediaItem(
      id: "https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3",
      album: "Science Friday",
      title: "From Cat Rheology To Operatic Incompetence",
      artist: "Science Friday and WNYC Studios",
      duration: Duration(milliseconds: 2856950),
      artUri: Uri.parse(
          "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
    ),
  ];

  int _queueIndex = -1;
  AudioProcessingState? _audioProcessingState;
  bool? _playing;

  bool get hasNext => _queueIndex + 1 < _queue.length;
  bool get hasPrevious => _queueIndex > 0;
  MediaItem get mediaItem => _queue[_queueIndex];

  late StreamSubscription<PlayerState> _playerStateSubscription;
  late StreamSubscription<PlaybackEvent> _eventSubscription;

  @override
  Future<void> onStart(Map<String, dynamic>? params) {
    _playerStateSubscription = audioPlayer.playerStateStream.listen((state) {
      switch (state.processingState) {
        case ProcessingState.completed:
          _handlePlaybackComplete();
          break;
        default:
      }
      if (_audioProcessingState == AudioProcessingState.connecting) {
        _setState(
          // connecting
          processingState:
              _audioProcessingState ?? AudioProcessingState.connecting,
          position: audioPlayer.position,
        );
      } else if (state.playing) {
        // playing
        _setState(
          processingState: _audioProcessingState ?? AudioProcessingState.ready,
          position: audioPlayer.position,
        );
      } else if (!state.playing) {
        // paused
        _setState(
          processingState: _audioProcessingState ?? AudioProcessingState.ready,
          position: audioPlayer.position,
        );
      }
    });

    AudioServiceBackground.setQueue(_queue);
    onSkipToNext();

    return super.onStart(params);
  }

  _handlePlaybackComplete() {
    if (hasNext) {
      onSkipToNext();
    } else {
      onStop();
    }
  }

  Future<void> _seekRelative(Duration offset) async {
    var newPosition = audioPlayer.playbackEvent.bufferedPosition + offset;
    if (newPosition < Duration.zero) {
      newPosition = Duration.zero;
    }
    if (newPosition > mediaItem.duration!) {
      newPosition = mediaItem.duration!;
    }
    await audioPlayer.seek(audioPlayer.playbackEvent.bufferedPosition + offset);
  }

  @override
  Future<void> onPause() {
    _playing = false;
    audioPlayer.pause();
    return super.onPause();
  }

  @override
  Future<void> onPlay() async {
    if (null == _audioProcessingState) {
      _playing = true;
      audioPlayer.play();
    }
  }

  @override
  Future<void> onSkipToNext() {
    skip(1);
    return super.onSkipToNext();
  }

  void skip(int offset) async {
    int newPos = _queueIndex + offset;
    if (!(newPos >= 0 && newPos < _queue.length)) {
      return;
    }
    if (null == _playing) {
      _playing = true;
    } else if (_playing!) {
      await audioPlayer.stop();
    }

    _queueIndex = newPos;
    _audioProcessingState = offset > 0
        ? AudioProcessingState.skippingToNext
        : AudioProcessingState.skippingToPrevious;
    AudioServiceBackground.setMediaItem(mediaItem);
    await audioPlayer.setUrl(mediaItem.id);
    _audioProcessingState = null;
    if (_playing!) {
      onPlay();
    } else {
      _setState(processingState: AudioProcessingState.ready);
    }
  }

  @override
  Future<void> onStop() async {
    _playing = false;
    await audioPlayer.stop();
    await audioPlayer.dispose();
    _playerStateSubscription.cancel();
    _eventSubscription.cancel();
    return super.onStop();
  }

  @override
  Future<void> onSkipToPrevious() {
    skip(-1);
    return super.onSkipToPrevious();
  }

  @override
  Future<void> onSeekTo(Duration position) {
    audioPlayer.seek(position);
    return super.onSeekTo(position);
  }

  @override
  Future<void> onClick(MediaButton button) {
    _playPause();
    return super.onClick(button);
  }

  @override
  Future<void> onFastForward() async {
    await _seekRelative(fastForwardInterval);
  }

  @override
  Future<void> onRewind() async {
    await _seekRelative(rewindInterval);
  }

  _playPause() {
    if (AudioServiceBackground.state.playing) {
      onPause();
    } else {
      onPlay();
    }
  }

  Future<void> _setState(
      {AudioProcessingState? processingState,
      Duration? position,
      Duration? bufferedPosition}) async {
    if (null == position) {
      position = audioPlayer.playbackEvent.bufferedPosition;
    }
    await AudioServiceBackground.setState(
        controls: getControls(),
        systemActions: [MediaAction.seekTo],
        processingState:
            processingState ?? AudioServiceBackground.state.processingState,
        playing: _playing,
        position: position,
        speed: audioPlayer.speed);
  }

  List<MediaControl> getControls() {
    if (_playing!) {
      return [
        skipToPrevControl,
        pauseControl,
        stopControl,
        skipToNextControl,
      ];
    } else {
      return [
        skipToPrevControl,
        playControl,
        stopControl,
        skipToNextControl,
      ];
    }
  }
}

class PlayerPage extends StatefulWidget {
  PlayerPage({
    Key? key,
    required this.audioUri,
    required this.album,
    required this.title,
    required this.artwork,
  });

  final String audioUri;
  final String album;
  final String title;
  final String artwork;

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  String audioUri = "";
  String album = "";
  String title = "";
  String artwork = "";

  late AudioPlayer _player;
  late ConcatenatingAudioSource _playlist;

  @override
  void initState() {
    super.initState();

    audioUri = widget.audioUri;
    title = widget.title;
    album = widget.album;
    artwork = widget.artwork;

    _playlist = ConcatenatingAudioSource(children: [
      AudioSource.uri(
        Uri.parse(audioUri),
        tag: AudioMetadata(
          album: album,
          title: title,
          artwork: artwork,
        ),
      ),
    ]);

    _player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    try {
      await _player.setAudioSource(_playlist);
      await AudioService.start(
          backgroundTaskEntrypoint: _audioTaskEntryPoint,
          androidNotificationChannelName: 'PodQast',
          androidNotificationColor: 0xFF2222f5,
          androidNotificationIcon: 'mipmap/ic_launcher');
    } catch (e) {
      // catch load errors: 404, invalid url ...
      print("An error occured $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<SequenceState?>(
                stream: _player.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) return SizedBox();
                  final metadata = state!.currentSource!.tag as AudioMetadata;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Image.network(metadata.artwork)),
                        ),
                      ),
                      Text(metadata.album,
                          style: Theme.of(context).textTheme.headline6),
                      Text(metadata.title),
                    ],
                  );
                },
              ),
            ),
            ControlButtons(_player),
            StreamBuilder<Duration?>(
              stream: _player.durationStream,
              builder: (context, snapshot) {
                final duration = snapshot.data ?? Duration.zero;
                return StreamBuilder<PositionData>(
                  stream: Rx.combineLatest2<Duration, Duration, PositionData>(
                      _player.positionStream,
                      _player.bufferedPositionStream,
                      (position, bufferedPosition) =>
                          PositionData(position, bufferedPosition)),
                  builder: (context, snapshot) {
                    final positionData = snapshot.data ??
                        PositionData(Duration.zero, Duration.zero);
                    var position = positionData.position;
                    if (position > duration) {
                      position = duration;
                    }
                    var bufferedPosition = positionData.bufferedPosition;
                    if (bufferedPosition > duration) {
                      bufferedPosition = duration;
                    }
                    return SeekBar(
                      duration: duration,
                      position: position,
                      bufferedPosition: bufferedPosition,
                      onChangeEnd: (newPosition) {
                        _player.seek(newPosition);
                      },
                    );
                  },
                );
              },
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                StreamBuilder<LoopMode>(
                  stream: _player.loopModeStream,
                  builder: (context, snapshot) {
                    final loopMode = snapshot.data ?? LoopMode.off;
                    const icons = [
                      Icon(Icons.repeat, color: Colors.grey),
                      Icon(Icons.repeat, color: Colors.orange),
                      Icon(Icons.repeat_one, color: Colors.orange),
                    ];
                    const cycleModes = [
                      LoopMode.off,
                      LoopMode.all,
                      LoopMode.one,
                    ];
                    final index = cycleModes.indexOf(loopMode);
                    return IconButton(
                      icon: icons[index],
                      onPressed: () {
                        _player.setLoopMode(cycleModes[
                            (cycleModes.indexOf(loopMode) + 1) %
                                cycleModes.length]);
                      },
                    );
                  },
                ),
                Expanded(
                  child: Text(
                    "Playlist",
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
                StreamBuilder<bool>(
                  stream: _player.shuffleModeEnabledStream,
                  builder: (context, snapshot) {
                    final shuffleModeEnabled = snapshot.data ?? false;
                    return IconButton(
                      icon: shuffleModeEnabled
                          ? Icon(Icons.shuffle, color: Colors.orange)
                          : Icon(Icons.shuffle, color: Colors.grey),
                      onPressed: () async {
                        final enable = !shuffleModeEnabled;
                        if (enable) {
                          await _player.shuffle();
                        }
                        await _player.setShuffleModeEnabled(enable);
                      },
                    );
                  },
                ),
              ],
            ),
            Container(
              height: 240.0,
              child: StreamBuilder<SequenceState?>(
                stream: _player.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  final sequence = state?.sequence ?? [];
                  return ReorderableListView(
                    onReorder: (int oldIndex, int newIndex) {
                      if (oldIndex < newIndex) newIndex--;
                      _playlist.move(oldIndex, newIndex);
                    },
                    children: [
                      for (var i = 0; i < sequence.length; i++)
                        Dismissible(
                          key: ValueKey(sequence[i]),
                          background: Container(
                            color: Colors.redAccent,
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                          onDismissed: (dismissDirection) {
                            _playlist.removeAt(i);
                          },
                          child: Material(
                            color: i == state!.currentIndex
                                ? Colors.grey.shade300
                                : null,
                            child: ListTile(
                              title: Text(sequence[i].tag.title as String),
                              onTap: () {
                                _player.seek(Duration.zero, index: i);
                              },
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _audioTaskEntryPoint(AudioPlayer audioPlayer) async {
  AudioServiceBackground.run(() => AudioPlayerTask(audioPlayer));
}
