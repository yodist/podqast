import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/PodcastService.dart';
import 'package:flutter_application_1/widget/PodcastSearch.dart';
import 'package:flutter_application_1/widget/podcastHome.dart';
import 'package:audio_service/audio_service.dart';

import 'component/audio/AudioPlayerTask.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PodcastService podcastService = PodcastService();

  late List<Widget> _widgetOptions;
  late Future<Map<String, dynamic>> futureBestPod;

  @override
  void initState() {
    super.initState();

    AudioService.start(
      backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
      androidNotificationChannelName: 'PodQast',
      // Enable this if you want the Android service to exit the foreground state on pause.
      //androidStopForegroundOnPause: true,
      androidNotificationColor: 0xFF2196f3,
      androidNotificationIcon: 'mipmap/ic_launcher',
      androidEnableQueue: true,
    );

    futureBestPod = podcastService.fetchBestPodcasts();

    _widgetOptions = <Widget>[
      PodcastHomeTab(data: futureBestPod),
      PodcastSearch(),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // navigationBar: CupertinoNavigationBar(
      //   middle: Image(
      //     image: AssetImage('assets/image/PodQast.png'),
      //     height: 35,
      //   ),
      //   backgroundColor: Colors.white,
      // ),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.house)),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
          ),
        ]),
        tabBuilder: (BuildContext context, index) {
          return _widgetOptions[index];
        },
      ),
    );
  }
}

// NOTE: Your entrypoint MUST be a top-level function.
void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}
