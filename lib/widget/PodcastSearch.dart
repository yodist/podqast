import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/PodcastListPage.dart';
import 'package:flutter_application_1/service/PodcastService.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class PodcastSearch extends StatefulWidget {
  @override
  _PodcastSearchState createState() => _PodcastSearchState();
}

class _PodcastSearchState extends State<PodcastSearch> {
  PodcastService podcastService = PodcastService();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                  autofocus: true,
                  style: DefaultTextStyle.of(context)
                      .style
                      .copyWith(fontStyle: FontStyle.italic, fontSize: 18),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Search podcast title or publisher name",
                  )),
              suggestionsCallback: (pattern) async {
                return await podcastService.getSuggestions(pattern);
              },
              itemBuilder: (context, Map<String, dynamic> suggestion) {
                return ListTile(
                  leading: Image.network(suggestion['thumbnail']),
                  title: Html(data: suggestion['title_highlighted'], style: {
                    "*": Style(fontSize: FontSize.large),
                    ".ln-search-highlight":
                        Style(backgroundColor: Colors.amber),
                  }),
                  subtitle: Text(suggestion['publisher_original']),
                );
              },
              onSuggestionSelected: (suggestion) {
                Map<String, dynamic> sugg =
                    (suggestion! as Map<String, dynamic>);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PodcastListPage(
                          sugg['id'],
                          title: sugg['title_original'],
                          imageUrl: sugg['image'],
                          publisher: sugg['publisher_original'],
                        )));
              },
            )
          ],
        ));
  }
}
