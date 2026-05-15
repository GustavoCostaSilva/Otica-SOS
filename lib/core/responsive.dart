import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Responsive {
  static bool isTV(BuildContext context) {
    if (kIsWeb) {
      return MediaQuery.of(context).size.width > 1200;
    }
    return defaultTargetPlatform == TargetPlatform.linux || 
           MediaQuery.of(context).size.width > 1200;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }
}
