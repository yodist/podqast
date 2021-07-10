import 'package:flutter/foundation.dart';
import 'package:podqast/model/db/user.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
// ignore: prefer_mixin
class MainProvider with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;
  bool _showMiniPlayer = false;
  User? _user;

  int get count => _count;
  bool get showMiniPlayer => _showMiniPlayer;
  User? get currentUser => _user;

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

  void updateUser(User user) {
    _user = user;
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
    properties.add(StringProperty('showMiniPlayer', showMiniPlayer.toString()));
  }
}
