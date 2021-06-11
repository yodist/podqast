import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/PodcastListPage.dart';
import 'package:flutter_application_1/service/PodcastService.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_typeahead/cupertino_flutter_typeahead.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';

class PodcastSearch extends StatefulWidget {
  @override
  _PodcastSearchState createState() => _PodcastSearchState();
}

class _PodcastSearchState extends State<PodcastSearch> {
  PodcastService podcastService = PodcastService();
  final TextEditingController _typeAheadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            CupertinoTypeAheadFormField(
              textFieldConfiguration: CupertinoTextFieldConfiguration(
                  autofocus: true,
                  style: DefaultTextStyle.of(context)
                      .style
                      .copyWith(fontStyle: FontStyle.italic, fontSize: 18),
                  controller: _typeAheadController,
                  placeholder: 'Search podcast title or publisher name'),
              suggestionsCallback: (pattern) async {
                return await podcastService.getSuggestions(pattern);
              },
              itemBuilder: (context, Map<String, dynamic> suggestion) {
                return Material(
                    child: ListTile(
                  leading: Image.network(suggestion['thumbnail']),
                  title: Html(data: suggestion['title_highlighted'], style: {
                    "*": Style(fontSize: FontSize.large),
                    ".ln-search-highlight":
                        Style(backgroundColor: Colors.amber),
                  }),
                  subtitle: Text(suggestion['publisher_original']),
                ));
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
