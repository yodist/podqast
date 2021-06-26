import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
// ignore: prefer_mixin
class MainProvider with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;
  bool _showMiniPlayer = false;
  User? _user;

  int get count => _count;
  bool get showMiniPlayer => _showMiniPlayer;
  User? get user => _user;

  void increment() {
    _count++;
    notifyListeners();
  }

  void showPlayer() {
    _showMiniPlayer = true;
    notifyListeners();
  }

  void hidePlayer() {
    _showMiniPlayer = false;
    notifyListeners();
  }

  void setUser(User user) {
    _user = user;
  }

  void removeUser(User user) {
    _user = null;
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
    properties.add(StringProperty('showMiniPlayer', showMiniPlayer.toString()));
    properties
        .add(StringProperty('user', user != null ? user!.displayName : 'null'));
  }
}
