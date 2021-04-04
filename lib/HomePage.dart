import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/PodcastController.dart';
import 'package:flutter_application_1/widget/PodcastSearch.dart';
import 'package:flutter_application_1/widget/podcastHome.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;
  late Future<Map<String, dynamic>> futureBestPod;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 250), curve: Curves.ease);
    });
  }

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    futureBestPod = fetchBestPodcasts();

    _widgetOptions = <Widget>[
      podcastHome(futureBestPod),
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          title: Image(
            image: AssetImage('assets/image/PodQast.png'),
            height: 35,
          ),
          backgroundColor: Colors.white,
        ),
      ),
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
