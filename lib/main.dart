import 'package:audio_service/audio_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:podqast/screens/home_page.dart';
import 'package:podqast/providers/main_provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:podqast/screens/login_page.dart';
import 'package:provider/provider.dart';

void main() async {
  // to ensure everything is initialized before runApp, for this case, is
  // global config load from app_config
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MainProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget firstWidget = LoginPage();

    if (FirebaseAuth.instance.currentUser != null) {
      firstWidget = HomePage(title: 'Podqast');
    }

    return OverlaySupport.global(
        child: CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'PodQast',
      theme: new CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.systemPurple,
        barBackgroundColor: CupertinoColors.white,
        scaffoldBackgroundColor: CupertinoColors.white,
        textTheme: new CupertinoTextThemeData(
          primaryColor: CupertinoColors.white,
          textStyle: TextStyle(color: CupertinoColors.black),
          // ... here I actually utilised all possible parameters in the constructor
          // as you can see in the link underneath
        ),
      ),
      home: AudioServiceWidget(
        // child: HomePage(
        //   title: "PodQast",
        // ),
        child: firstWidget,
      ),
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
    ));
  }
}
