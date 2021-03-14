import 'package:flutter/material.dart';

class PodcastListPage extends StatefulWidget {
  PodcastListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PodcastListPageState createState() => _PodcastListPageState();
}

class _PodcastListPageState extends State<PodcastListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: Text('Fuck!'),
        ),
      ),
    );
  }
}
