import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:podqast/screens/podcast_list_page.dart';
import 'package:podqast/screens/podcast_result_page.dart';
import 'package:podqast/service/podcast_service.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_typeahead/cupertino_flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';

class PodcastSearch extends StatefulWidget {
  @override
  _PodcastSearchState createState() => _PodcastSearchState();
}

class _PodcastSearchState extends State<PodcastSearch>
    with AutomaticKeepAliveClientMixin<PodcastSearch> {
  PodcastService podcastService = PodcastService();
  final TextEditingController _typeAheadController = TextEditingController();

  late Future<Map<String, dynamic>> genreData;

  @override
  void initState() {
    super.initState();

    genreData = podcastService.fetchGenres();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          heroTag: 'tab2',
          transitionBetweenRoutes: false,
          middle: Image(
            image: AssetImage('assets/image/PodQast.png'),
            height: 35,
          ),
          backgroundColor: Colors.white,
        ),
        child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CupertinoTypeAheadFormField(
                  textFieldConfiguration: CupertinoTextFieldConfiguration(
                      autofocus: false,
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontStyle: FontStyle.italic, fontSize: 18),
                      controller: _typeAheadController,
                      placeholder: 'Search podcast title or publisher name',
                      onEditingComplete: () {
                        Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            PodcastResultPage(_typeAheadController.text)));
                      }),
                  suggestionsCallback: (pattern) async {
                    return Future.delayed(
                      Duration(seconds: 1),
                      () => podcastService.getSuggestions(pattern),
                    );
                    // return await podcastService.getSuggestions(pattern);
                  },
                  itemBuilder: (context, String suggestion) {
                    return Material(
                        child: Text(
                      suggestion,
                      style: TextStyle(fontSize: 20),
                    ));
                  },
                  noItemsFoundBuilder: (context) {
                    return Material(
                        child: Text(
                      'No items found',
                      style: TextStyle(fontSize: 20),
                    ));
                  },
                  onSuggestionSelected: (suggestion) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            PodcastResultPage(suggestion as String)));
                  },
                  // itemBuilder: (context, Map<String, dynamic> suggestion) {
                  //   return Material(
                  //       child: ListTile(
                  //     leading: Image.network(suggestion['thumbnail']),
                  //     title:
                  //         Html(data: suggestion['title_highlighted'], style: {
                  //       "*": Style(fontSize: FontSize.large),
                  //       ".ln-search-highlight":
                  //           Style(backgroundColor: Colors.amber),
                  //     }),
                  //     subtitle: Text(suggestion['publisher_original']),
                  //   ));
                  // },
                  // onSuggestionSelected: (suggestion) {
                  //   Map<String, dynamic> sugg =
                  //       (suggestion! as Map<String, dynamic>);
                  //   Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (context) => PodcastListPage(
                  //             sugg['id'],
                  //             title: sugg['title_original'],
                  //             imageUrl: sugg['image'],
                  //             publisher: sugg['publisher_original'],
                  //           )));
                  // },
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    'Category',
                    style: GoogleFonts.openSans(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[400]),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: FutureBuilder(
                    future: genreData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var colorList = [
                          0xFF5865f2,
                          0xFFed4245,
                          0xFF9656ce,
                          0xFF5b209a,
                          0xFFe8cd02,
                          0xFF3065d2,
                          0xFFf47b68,
                          0xFFf57731,
                          0xFFf9c9a9,
                        ];
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2,
                          ),
                          itemCount: (snapshot.data! as Map)['genres'].length,
                          itemBuilder: (_, int position) {
                            var snapshotData = (snapshot.data! as Map);
                            var name =
                                snapshotData['genres'][position]['name'] ?? '';
                            return
                                // Row(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   mainAxisSize: MainAxisSize.min,
                                //   children: [
                                Card(
                              color:
                                  Color(colorList[position % colorList.length]),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                onTap: () {},
                                child: Container(
                                  // color: Color(
                                  //     colorList[position % colorList.length]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      name,
                                      style: GoogleFonts.openSans(
                                          fontSize: 22, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            );
                            //   ],
                            // );
                          },
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ],
            )));
  }
}
