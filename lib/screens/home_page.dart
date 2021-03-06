import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:podqast/providers/main_provider.dart';
import 'package:podqast/widgets/overlay_player.dart';
import 'package:podqast/widgets/podcast_search.dart';
import 'package:podqast/widgets/podcast_home_tab.dart';
import 'package:audio_service/audio_service.dart';
import 'package:provider/provider.dart';

import '../service/audio/audio_player_task.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late PageController _pageController;
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 250), curve: Curves.ease);
    });
    // showSimpleNotification(Text("Hello"),
    //     position: NotificationPosition.bottom,
    //     slideDismissDirection: DismissDirection.down,
    //     autoDismiss: false);
  }

  @override
  void initState() {
    super.initState();

    // if (!AudioService.running) {
    //   startAudioService();
    // }

    _pageController = PageController();

    _widgetOptions = <Widget>[
      PodcastHomeTab(),
      PodcastSearch(),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(60.0),
      //   child: AppBar(
      //     title: Image(
      //       image: AssetImage('assets/image/PodQast.png'),
      //       height: 35,
      //     ),
      //     backgroundColor: Colors.white,
      //   ),
      // ),
      body: SizedBox.expand(
          child: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _widgetOptions,
      )),
      persistentFooterButtons: <Widget>[
        // Visibility(
        //     visible:
        StreamBuilder<bool>(
          stream: AudioService.runningStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.active) {
              // Don't show anything until we've ascertained whether or not the
              // service is running, since we want to show a different UI in
              // each case.
              return SizedBox();
            }
            return snapshot.data!
                ? Container(height: 120, width: 400, child: OverlayPlayer())
                : SizedBox();
          },
        ),
        // child: Container(height: 120, width: 400, child: OverlayPlayer())
        // )
        // ,
      ],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        onTap: _onItemTapped,
      ),
    );
  }
}

Future<void> startAudioService() async {
  await AudioService.start(
    backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
    androidNotificationChannelName: 'PodQast',
    // Enable this if you want the Android service to exit the foreground state on pause.
    //androidStopForegroundOnPause: true,
    androidNotificationColor: 0xFF2196f3,
    androidNotificationIcon: 'mipmap/ic_launcher',
    androidEnableQueue: true,
  );
}

// NOTE: Your entrypoint MUST be a top-level function.
void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}
