import 'package:flutter/material.dart';
import 'package:flutter_application_1/HomePage.dart';

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
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => HomePage(title: "PodQast")));
  }

  Widget googleLoginButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          image: AssetImage('assets/image/PodQast.png'),
          height: 60,
        ),
        SizedBox(height: 30),
        Text('Listen to your favorite podcast anytime ' +
            'anywhere and customize your podcast playlist'),
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
                      borderRadius: BorderRadius.circular(45),
                      side: BorderSide(color: Colors.grey)),
                  textStyle: TextStyle(),

                  // splashColor: Colors.grey,
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Sign in',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ))
          ],
        )
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
