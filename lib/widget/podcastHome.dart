import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/podcastBlock.dart';
import 'package:google_fonts/google_fonts.dart';

Widget podcastHome(Future<Map<String, dynamic>> data) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Container(
        margin: EdgeInsets.fromLTRB(15, 10, 0, 10),
        child: Text(
          "Top Podcasts",
          style: TextStyle(fontSize: 28),
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
