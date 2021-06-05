import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/HomePage.dart';
import 'package:flutter_application_1/LoginPage.dart';
import 'package:flutter_application_1/example/ExampleAudioService.dart';

void main() async {
  // to ensure everything is initialized before runApp, for this case, is
  // global config load from app_config
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PodQast',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AudioServiceWidget(
        child: MainScreen(),
      ),
    );
  }
}
