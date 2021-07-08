import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:podqast/screens/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:podqast/service/authentication.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
  }

  void click() {
    signInWithGoogle().then((user) {
      if (user == null) {
        toast('Please choose your Google Account to Login');
      } else {
        Navigator.pushReplacementNamed(context, '/');
      }
    }).onError((error, stackTrace) {
      toast('Something is wrong, please try again later.');
      return null;
    });
  }

  Widget googleLoginButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 100),
        Image(
          image: AssetImage('assets/image/PodQast.png'),
          height: 60,
        ),
        SizedBox(height: 30),
        Container(
          child: Text(
            'Listen your favorite podcasts',
            style: GoogleFonts.robotoCondensed(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          width: 250,
        ),
        SizedBox(height: 60),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Center(
              child: OutlinedButton(
                onPressed: this.click,
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey)),
                  backgroundColor: Colors.grey[800],
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Sign in',
                          style: GoogleFonts.montserrat(
                              fontSize: 20, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ))
          ],
        ),
        SizedBox(height: 30),
        Container(
          child: Text(
            "Don't have an account? Sign up here",
            style: GoogleFonts.robotoCondensed(
                fontSize: 18, color: Color(0xff6734F6)),
            textAlign: TextAlign.center,
          ),
          width: 180,
        ),
        SizedBox(height: 20),
        Container(
          child: Text(
            "or",
            style: GoogleFonts.robotoCondensed(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          width: 180,
        ),
        SizedBox(height: 20),
        Container(
          child: Text(
            "Listen as a guest",
            style: GoogleFonts.robotoCondensed(
                fontSize: 18, color: Color(0xff6734F6)),
            textAlign: TextAlign.center,
          ),
          width: 180,
        ),
        SizedBox(height: 90),
        Container(
          child: Text(
            "Developed by Yodist team",
            style: GoogleFonts.robotoCondensed(
                fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          width: 100,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: googleLoginButton(),
    );
  }
}
