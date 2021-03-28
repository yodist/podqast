import 'package:flutter/material.dart';
import 'package:flutter_application_1/PodcastListPage.dart';
import 'package:flutter_application_1/util/StringUtil.dart';

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
              leading: Image(
                image: NetworkImage(iconUrl),
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
