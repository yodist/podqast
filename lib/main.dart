import 'package:flutter/material.dart';
import 'package:flutter_application_1/LoginPage.dart';
import 'package:global_configuration/global_configuration.dart';

void main() async {
  // to ensure everything is initialized before runApp, for this case, is
  // global config load from app_config
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("app_config");
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
      home: LoginPage(),
    );
  }
}
