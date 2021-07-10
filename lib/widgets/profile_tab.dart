import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:podqast/screens/login_page.dart';
import 'package:podqast/service/authentication.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late User? user;

  @override
  void initState() {
    super.initState();

    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          heroTag: 'tab3',
          transitionBetweenRoutes: false,
          middle: Image(
            image: AssetImage('assets/image/PodQast.png'),
            height: 35,
          ),
          backgroundColor: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(width: 0.75, color: Colors.grey)),
              ),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      width: 128.0,
                      height: 128.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(64.0),
                        child: CachedNetworkImage(
                          imageUrl: user!.photoURL!,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.grey.shade200),
                          ),
                          fit: BoxFit.fill,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        user!.displayName!,
                        style: GoogleFonts.openSans(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                CupertinoListTile(
                  title: Text(
                    'Account',
                    style: GoogleFonts.openSans(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                CupertinoListTile(
                  title: Text(
                    'Playback',
                    style: GoogleFonts.openSans(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                CupertinoListTile(
                  title: Text(
                    'About',
                    style: GoogleFonts.openSans(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
                // SystemNavigator.pop();
              },
              child: Text(
                'Sign Out',
                style: GoogleFonts.openSans(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36.0),
                          side: BorderSide(color: Colors.red.shade200)))),
            ),
          ],
        ));
  }
}
