import 'package:flutter/material.dart';

final ThemeData kShrineTheme = _buildShrineTheme();

ThemeData _buildShrineTheme() {
  return ThemeData(
    primaryColor: Color.fromRGBO(109, 234, 255, 1),
    accentColor: Color.fromRGBO(72, 74, 126, 1),
    brightness: Brightness.dark,
  );
}
