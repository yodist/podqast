import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/PodcastController.dart';
import 'package:flutter_application_1/widget/podcastBlock.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;
  late Future<Map<String, dynamic>> futureBestPod;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    futureBestPod = fetchBestPodcasts();

    _widgetOptions = <Widget>[
      podcastHome(futureBestPod),
      Text('Index 1: Business'),
    ];
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
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
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

Widget podcastHome(Future<Map<String, dynamic>> data) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Container(
        margin: EdgeInsets.fromLTRB(15, 10, 0, 10),
        child: Text(
          "Top Podcasts",
          style: GoogleFonts.robotoCondensed(
              fontSize: 28, fontWeight: FontWeight.bold),
        ),
        alignment: Alignment.centerLeft,
      ),
      Container(
        alignment: Alignment.topLeft,
        height: 250.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            FutureBuilder(
                future: data,
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: (snapshot.data! as Map)['podcasts'].length,
                          itemBuilder: (_, int position) {
                            var snapshotData = (snapshot.data! as Map);
                            final item = snapshotData['podcasts'][position];
                            return podcastBlock(context, item['id'],
                                item['image'], item['title'],
                                publisher: item['publisher'],
                                description: item['description'],
                                genreIds: item['genreIds']);
                          },
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                }),
          ],
        ),
      ),
    ],
  );
}
