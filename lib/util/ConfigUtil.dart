import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';

class ConfigUtil {
  static Future<Map<String, dynamic>> getConfigData() async {
    return json
        .decode(await rootBundle.loadString('assets/cfg/app_config.json'));
  }

  static OverlaySupportEntry? currentOverlay;
}
