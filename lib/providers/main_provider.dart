import 'package:flutter/foundation.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
// ignore: prefer_mixin
class MainProvider with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;
  bool _showMiniPlayer = false;

  int get count => _count;
  bool get showMiniPlayer => _showMiniPlayer;

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

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
    properties.add(StringProperty('showMiniPlayer', showMiniPlayer.toString()));
  }
}
