import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podqast/screens/podcast_list_page.dart';
import 'package:podqast/util/string_util.dart';

class MyCard extends StatelessWidget {
  MyCard(
      {Key? key,
      required this.iconUrl,
      required this.title,
      this.subtitle = ""})
      : super(key: key);

  final String iconUrl;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PodcastListPage(
                      "123",
                      title: "PodQast",
                    )),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 10),
            ListTile(
              leading: CachedNetworkImage(
                imageUrl: iconUrl,
                placeholder: (context, url) => CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.grey.shade200),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              title: Text(title),
              subtitle: Text(
                StringUtil.parseHtmlString(subtitle),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
