import 'package:flutter/material.dart';

class AppIcons {
  static const String _path = 'assets';

  static const String logoPath = '$_path/icon.png';

  static Widget logo({double? height, double? width}) {
    return Image.asset(logoPath, height: height, width: width);
  }
}
